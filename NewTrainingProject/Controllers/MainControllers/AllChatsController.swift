//
//  AllChatsController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 23.12.2022.
//

import UIKit

class AllChatsController: UITableViewController {
    
    private var chats = [
    "Драконя Вошка"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController(){
        title = "AllChatsController"
        view.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "chat")
        BackButton(vc: self).createBackButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.message.fill"), style: .done, target: self, action: #selector(goToNewChat))
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
        let viewController = ChatController(with: (userUid as? String)!)
        viewController.title = userName as? String
        viewController.isNewChat = true
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chat", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = chats[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - SwiftUI
import SwiftUI
struct AllChatsController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // Return whatever controller you want to preview
            let viewController = UINavigationController(rootViewController: AllChatsController())
            return viewController
        }.edgesIgnoringSafeArea(.all)
            
    }
}
