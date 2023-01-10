//
//  DataBaseManager.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 22.12.2022.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

final class DataBaseManager {
    static let shared = DataBaseManager()
    
    private let dataBase = Firestore.firestore()
    
    //MARK: - Account management
    public func saveNewUser(users: ChatUsers, errorLabel: DefaultUILabel){
        dataBase.collection("users").document("\(users.uid)").setData([
            "name" : "\(users.firstName) \(users.lastName)",
            "uid" : users.uid
        ]) { error in
            if error != nil {
                errorLabel.text = "Error savind user in dataBase"
            }
        }
    }
    
    public func getUserName(user: User, completion: @escaping (Result<String, Error>) -> Void){
        
        let documentReference = dataBase.collection("users").document("\(user.uid)")
        
        documentReference.getDocument { document, error in
            if let document = document, document.exists {
                document.data()?.map({ (key: String, value: Any) in
                    if key == "name"{
                        completion(.success(value as! String))
                    }
                })
            } else {
                if let error = error{
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func getAllUsers(completion: @escaping (Result<[String: Any], Error>) -> Void){
        dataBase.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(error))
            } else {
                for document in snapshot!.documents {
                    completion(.success(document.data()))
                    
                }
            }
                
        }
    }
}

//MARK: - Sending messages and Chats
extension DataBaseManager {
    /// Create new CHat with targetUser
    public func createNewChat(with otherUserUid: String, name: String, firstMessage: ChatMessage, completion: @escaping (Bool) -> Void){
        let user = Auth.auth().currentUser
        if let user = user{
            var displayName: String = ""
            DataBaseManager.shared.getUserName(user: user){result in
                switch result {
                case .success(let userName):
                    displayName = userName
                case .failure(let error):
                    print("Failed to get User Name: \(error)")
                }
            }
            
            let reference = dataBase.collection("users")
            reference.document("\(user.uid)").getDocument { snapshot, error in
                guard snapshot?.data() is [String: Any] else {
                    completion(false)
                    print("user not found")
                    return
                }
                
                let chatId = "chat_\(firstMessage.messageID)"
                
                let newChatData: [String: Any] = [
                    "id": chatId,
                    "name": name,
                    "otherUserUid": otherUserUid,
                    "latestMessage": [
                        "date": firstMessage.date,
                        "message": firstMessage.text,
                        "is_read": false as Any
                    ]
                ]
                
                let recipient_newChatData: [String: Any] = [
                    "id": chatId,
                    "name": displayName,
                    "otherUserUid": user.uid,
                    "latestMessage": [
                        "date": firstMessage.date,
                        "message": firstMessage.text,
                        "is_read": true as Any
                    ]
                ]
                // update recipient user chat
                reference.document("\(otherUserUid)").collection("userChats").document("\(chatId)").setData(recipient_newChatData) {[weak self] error in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingChat(chatId: chatId, name: name, firstMessage: firstMessage, completion: completion)
                }
                
                // update current user chat
                reference.document("\(user.uid)").collection("userChats").document("\(chatId)").setData(newChatData) {[weak self] error in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingChat(chatId: chatId, name: name, firstMessage: firstMessage, completion: completion)
                }
            }
        }
    }
    
    public func finishCreatingChat(chatId: String, name: String, firstMessage: ChatMessage, completion: @escaping (Bool) -> Void){
        let user = Auth.auth().currentUser
        
        if let user = user {
        
            let collectionMessage: [String: Any] = [
                "id": firstMessage.messageID,
                "type": "text",
                "content": firstMessage.text,
                "date": firstMessage.date,
                "sender_uid": user.uid as Any,
                "is_read": false,
                "name": name
            ]

            dataBase.collection("chats").document("\(chatId)").collection("messages").document("\(firstMessage.messageID)").setData(collectionMessage) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    /// Fetches and return all chats for user
    public func getAllChats(for userUid: String, completion: @escaping (Result<[Chats], Error>) -> Void){
        
        dataBase.collection("users").document("\(userUid)").collection("userChats").addSnapshotListener { snapshot, error in

            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            let chats: [Chats] = documents.compactMap { dictionary in

                guard let chatId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserUid = dictionary["otherUserUid"] as? String,
                      let latestMessage = dictionary["latestMessage"] as? [String: Any],
                      let date = latestMessage["date"] as? Timestamp,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {
                    let latestMessageObject = LatestMessage(date: "error", text: "error", isREad: false)
                    return Chats(id: "error", name: "error", otherUserId: "error", latestMessage: latestMessageObject)
                }

                let dateString = CustomDate.dateStringFromFirestone(stamp: date)
                let latestMessageObject = LatestMessage(date: dateString, text: message, isREad: isRead)
                return Chats(id: chatId, name: name, otherUserId: otherUserUid, latestMessage: latestMessageObject)

            }
            completion(.success(chats))
        }
    }
    /// Get all messages for a given chat
    public func getAllMessagesForChat(with id: String, forSender: Sender, completion: @escaping (Result<[ChatMessage],Error>) -> Void){
        
        
        dataBase.collection("chats").document("\(id)").collection("messages").addSnapshotListener { snapshot, error in

            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(DatabaseError.filedToFetch)")
                return
            }

            let messages: [ChatMessage] = documents.compactMap { dictionary in

                guard let name = dictionary["name"] as? String,
                let isRead = dictionary["is_read"] as? Bool,
                let messageId = dictionary["id"] as? String,
                let content = dictionary["content"] as? String,
                let senderUid = dictionary["sender_uid"] as? String,
                let type = dictionary["type"] as? String,
                let date = dictionary["date"] as? Timestamp else {
                    print("Document error")
                    let sender = Sender(photoURL: "", senderId: "", displayName: "")
                    return ChatMessage(sender: sender, messageID: "error", text: "error", isIncoming: false, date: Date())
                }

                let sender = Sender(photoURL: "", senderId: senderUid, displayName: name)

                if senderUid == forSender.senderId {
                    return ChatMessage(sender: sender, messageID: messageId, text: content, isIncoming: isRead, date: date.dateValue())
                } else {
                    return ChatMessage(sender: sender, messageID: messageId, text: content, isIncoming: true, date: date.dateValue())
                }
                
            }
            
            completion(.success(messages))

        }
    }
    /// Send message with target chat and message
    public func sendMessage(to chat: String, otherUserUid: String, name: String, message: ChatMessage, completion: @escaping (Bool) -> Void){
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            var displayName: String = ""
            DataBaseManager.shared.getUserName(user: user){result in
                switch result {
                case .success(let userName):
                    displayName = userName
                case .failure(let error):
                    print("Failed to get User Name: \(error)")
                }
            }
            let reference = dataBase.collection("chats")
            
            let collectionMessage: [String: Any] = [
                "id": message.messageID,
                "type": "text",
                "content": message.text,
                "date": message.date,
                "sender_uid": user.uid as Any,
                "is_read": false,
                "name": name
            ]
            
            reference.document("\(chat)").collection("messages").document("\(message.messageID)").setData(collectionMessage) { [weak self] error in
                guard let strongSelf = self else {
                    return
                }
                
                guard error == nil else {
                    completion(false)
                    return
                }
    /// update last message for current User
    strongSelf.dataBase.collection("users").document("\(user.uid)").collection("userChats").document("\(chat)").getDocument { snapshot, error in
        if snapshot?.data() is [String: Any] {
                        strongSelf.dataBase.collection("users").document("\(user.uid)").collection("userChats").document("\(chat)").updateData(
                            [
                                "latestMessage": [
                                    "date": message.date,
                                    "message": message.text,
                                    "is_read": false
                                ]
                            ]
                        )
                    }else{
                        let newChatData: [String: Any] = [
                            "id": chat,
                            "name": name,
                            "otherUserUid": otherUserUid,
                            "latestMessage": [
                                "date": message.date,
                                "message": message.text,
                                "is_read": false
                            ]
                        ]
                        strongSelf.dataBase.collection("users").document("\(user.uid)").collection("userChats").document("\(chat)").setData(newChatData)
                    }
                }
    /// update last message for recipient User
                strongSelf.dataBase.collection("users").document("\(otherUserUid)").collection("userChats").document("\(chat)").getDocument { snapshot, error in
                    if snapshot?.data() is [String: Any] {
                        strongSelf.dataBase.collection("users").document("\(otherUserUid)").collection("userChats").document("\(chat)").updateData(
                                        [
                                            "latestMessage": [
                                                "date": message.date,
                                                "message": message.text,
                                                "is_read": false
                                            ]
                                        ]
                                    )
                    }else{
                        let recipient_newChatData: [String: Any] = [
                            "id": chat,
                            "name": displayName,
                            "otherUserUid": user.uid,
                            "latestMessage": [
                                "date": message.date,
                                "message": message.text,
                                "is_read": true as Any
                            ]
                        ]
                        strongSelf.dataBase.collection("users").document("\(otherUserUid)").collection("userChats").document("\(chat)").setData(recipient_newChatData)
                    }
                }
                completion(true)
            }
        }
    }
    
    public func chatExist(with targetRecipientUid: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let senderUid = self.safeSenderUid()
        
        dataBase.collection("users").document("\(targetRecipientUid)").collection("userChats").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion(.failure(DatabaseError.filedToFetch))
                return
            }
            if let chats = documents.first(where: {
                guard let targetSenderUid = $0["otherUserUid"] as? String else {
                    return false
                }
                return senderUid == targetSenderUid
            }) {
                guard let id = chats["id"] as? String else {
                    completion(.failure(DatabaseError.filedToFetch))
                    return
                }
                completion(.success(id))
                return
            }
            completion(.failure(DatabaseError.filedToFetch))
            print("Filed to get chats...")
            return
        }
    }
    
    public func safeSenderUid() -> String {
        let user = Auth.auth().currentUser
        guard let safeSenderUid = user?.uid as? String else {
            print("User Uid is not a String")
            return "User Uid is not a String"
        }
        return safeSenderUid
    }
}

//MARK: - Delite chats and messages
extension DataBaseManager {
    public func deleteChat(chatUid: String, complrtion: @escaping (Bool) -> Void) {
        
        print("Start deleting chat with Uid: \(chatUid)")
        guard let user = Auth.auth().currentUser else {
            return
        }
        dataBase.collection("users").document("\(user.uid)").collection("userChats").document("\(chatUid)").delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
                complrtion(false)
            } else {
                print("Document successfully removed!")
                complrtion(true)
            }
        }
    }
}

public enum DatabaseError: Error {
    case filedToFetch
}
