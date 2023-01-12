//
//  AllChatsController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 23.12.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct Chats {
    let id: String
    let name: String
    let otherUserId: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isREad: Bool
}


class AllChatsController: UITableViewController {
    
    private var chats = [Chats]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningForChats()
    }
    
    private func setupController(){
        title = "AllChatsController"
        view.backgroundColor = .systemBackground
        tableView.register(AllChatCell.self, forCellReuseIdentifier: AllChatCell.id)
        BackButton(vc: self).createBackButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.message.fill"), style: .done, target: self, action: #selector(goToNewChat))
    }
    
    //MARK: - startListeningForChats
    private func startListeningForChats(){
        let user = Auth.auth().currentUser
        if let user = user{
            DataBaseManager.shared.getAllChats(for: user.uid) { [weak self] result in
                switch result{
                case .success(let chats):
                    guard !chats.isEmpty else {
                        print("chats is empty")
                        return
                    }
                    self?.chats = chats
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print("failed to get chat: \(error)")
                }
            }
        }
    }
    
    private func messageNotification(chat: Chats){
        let content = UNMutableNotificationContent()
        content.title = chat.name
        content.body = chat.latestMessage.text
        content.sound = .default
        content.categoryIdentifier = "messageNotification"
        //content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest.init(identifier: "messageNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
       // center.add(request)
    }
    
    @objc func goToNewChat(){
        let viewController = NewChatController()
        viewController.completion = { [weak self] result in
            guard let strongSelf = self else {return}
            
            let currentChat = strongSelf.chats
            if let targetChat = currentChat.first(where: {
                $0.otherUserId == result.uid
            }) {
                let viewController = ChatController(with: targetChat.otherUserId, id: targetChat.id)
                viewController.title = targetChat.name
                viewController.isNewChat = false
                viewController.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(viewController, animated: true)
            }else{
                strongSelf.createNewChat(result: result)
            }
        }
        let newChatNavigationController = UINavigationController(rootViewController: viewController)
        present(newChatNavigationController, animated: true)
    }
    
    private func createNewChat(result: SearchResults){
        let userName = result.name
        let userUid = result.uid
        
        DataBaseManager.shared.chatExist(with: userUid) { [weak self] results in
            guard let strongSelf = self else {return}
            
            switch results {
            case .success(let chatId):
                let viewController = ChatController(with: userUid, id: chatId)
                viewController.title = userName
                viewController.isNewChat = false
                viewController.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(viewController, animated: true)
            case .failure(_):
                let viewController = ChatController(with: userUid, id: nil)
                viewController.title = userName
                viewController.isNewChat = true
                viewController.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    //MARK: - UITableViewDataSource, UITableViewDelegate
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = chats[indexPath.row]
        messageNotification(chat: model)
        let cell = tableView.dequeueReusableCell(withIdentifier: AllChatCell.id, for: indexPath) as! AllChatCell
        cell.configure(with: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = chats[indexPath.row]
        openChat(model)
    }
    
    func openChat(_ model: Chats) {
        let viewController = ChatController(with: model.otherUserId, id: model.id)
        viewController.title = model.name
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить чат?") { _, _, complitionHandler in
            
            let chatUid = self.chats[indexPath.row].id
            
            tableView.beginUpdates()
            self.chats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            DataBaseManager.shared.deleteChat(chatUid: chatUid) {success in
                if !success {
                    //add allert for error
                    print("filed to delite")
                }
            }
            tableView.endUpdates()
            return complitionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

// MARK: - SwiftUI
//import SwiftUI
//struct AllChatsController_Previews: PreviewProvider {
//    static var previews: some View {
//        UIViewControllerPreview {
//            // Return whatever controller you want to preview
//            let viewController = UINavigationController(rootViewController: AllChatsController())
//            return viewController
//        }.edgesIgnoringSafeArea(.all)
//            
//    }
//}
