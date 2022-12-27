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
        startListeningForChats()
        
    }
    
    private func setupController(){
        title = "AllChatsController"
        view.backgroundColor = .systemBackground
        tableView.register(AllChatCell.self, forCellReuseIdentifier: AllChatCell.id)
        BackButton(vc: self).createBackButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.message.fill"), style: .done, target: self, action: #selector(goToNewChat))
    }
    
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
    
    @objc func goToNewChat(){
        let viewController = NewChatController()
        viewController.completion = { [weak self] result in
            print("\(result)")
            self?.createNewChat(result: result)
        }
        let newChatNavigationController = UINavigationController(rootViewController: viewController)
        present(newChatNavigationController, animated: true)
    }
    
    private func createNewChat(result: [String: Any]){
        guard let userName = result["name"], let userUid = result["uid"] else {
            return
        }
        let viewController = ChatController(with: (userUid as? String)!, id: nil)
        viewController.title = userName as? String
        viewController.isNewChat = true
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = chats[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: AllChatCell.id, for: indexPath) as! AllChatCell
        cell.configure(with: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = chats[indexPath.row]
        let viewController = ChatController(with: model.otherUserId, id: model.id)
        viewController.title = model.name
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
