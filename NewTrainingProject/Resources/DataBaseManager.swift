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
    public func createNewChat(with otherUserUid: String, firstMessage: ChatMessage, completion: @escaping (Bool) -> Void){
        let user = Auth.auth().currentUser
        if let user = user{
            let reference = dataBase.collection("users")
            reference.document("\(user.uid)").getDocument { snapshot, error in
                guard var document = snapshot?.data() as? [String: Any] else {
                    completion(false)
                    print("user not found")
                    return
                }
                
                let messageDate = firstMessage.date
                let dateString = CustomDate.dateString(date: messageDate)
                let chatId = "chat_\(firstMessage.messageID)"
                
                let newChatData: [String: Any] = [
                    "id": chatId,
                    "otherUserUid": otherUserUid,
                    "latestMessage": [
                        "date": dateString,
                        "message": firstMessage.text,
                        "is_read": false
                    ]
                ]
                
                if var chat = document["userChat"] as? [[String: Any]] {
                    chat.append(newChatData)
                    document["userChat"] = chat
                    reference.document("\(user.uid)").setData(document) { [weak self] error in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        self?.finishCreatingChat(chatId: chatId, firstMessage: firstMessage, completion: completion)
                    }
                } else {
                    document["userChat"] = [newChatData]
                    reference.document("\(user.uid)").setData(document) {[weak self] error in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        self?.finishCreatingChat(chatId: chatId, firstMessage: firstMessage, completion: completion)
                    }
                }
            }
        }
    }
    
    public func finishCreatingChat(chatId: String, firstMessage: ChatMessage, completion: @escaping (Bool) -> Void){
        #warning("сохраняется только одно сообщение")
        let user = Auth.auth().currentUser
        
        if let user = user {
            
            let messageDate = firstMessage.date
            let dateString = CustomDate.dateString(date: messageDate)
            
            let collectionMessage: [String: Any] = [
                "id": firstMessage.messageID,
                "type": "text",
                "content": firstMessage.text,
                "date": dateString,
                "sender_uid": user.uid as Any,
                "is_read": false
            ]
            
            let document: [String: Any] = [
                "message": [
                    collectionMessage
                ]
            ]
            
            dataBase.collection("chats").document("\(chatId)").setData(document) { error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    /// Fetches and return all chats for user
    public func getAllChats(for userUid: String, completion: @escaping (Result<String, Error>) -> Void){
        
    }
    /// Get all messages for a given chat
    public func getAllMessagesForChat(with id: String, completion: @escaping (Result<String,Error>) -> Void){
        
    }
    /// Send message with target chat and message
    public func sendMessage(to chat: String, message: ChatMessage, completion: @escaping (Bool) -> Void){
        
    }
}

