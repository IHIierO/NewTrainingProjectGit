//
//  ChatController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 17.12.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatController: UIViewController {
    
    public var otherUserUid: String
    public var isNewChat = false
    
    private var selfSender: ChatUsers? {
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            guard let email = user.email else {return nil}
            
          return ChatUsers(firstName: "String",
                      lastName: "String",
                      email: email,
                      uid: user.uid)
        }
        
        return nil
    }
    
    var textMessagesArray = [[ChatMessage]]()
//    var messageFromServer = [
//
//    ]
    private func attemptToAssambleGroupedMessage(){
//        let groupedMessage = Dictionary(grouping: messageFromServer) { message -> Date in
//            return message.date
//        }
//
//        let sortedKeys = groupedMessage.keys.sorted()
//        sortedKeys.forEach { (key) in
//            let values = groupedMessage[key]
//            textMessagesArray.append(values ?? [])
//        }
    }
    
    private let tableView = UITableView()
    private let sendTextFiend = DefaultUITextField(placeholderText: "Aa")
    private let sendButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.image = UIImage(systemName: "paperplane.circle")
        button.configuration?.baseBackgroundColor = .systemBlue
        button.configuration?.baseForegroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(with uid: String){
        self.otherUserUid = uid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController(){
        attemptToAssambleGroupedMessage()
        BackButton(vc: self).createBackButton()
        view.backgroundColor = .systemMint
        title = "Chat"
        view.addSubview(sendTextFiend)
        sendTextFiend.delegate = self
        view.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            sendTextFiend.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            sendTextFiend.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sendTextFiend.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            sendTextFiend.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            
            sendButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            sendButton.leadingAnchor.constraint(equalTo: sendTextFiend.trailingAnchor, constant: 10),
            sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            sendButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sendTextFiend.topAnchor)
        ])
        
        
    }
     
}

extension ChatController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return textMessagesArray.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = textMessagesArray[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: firstMessageInSection.date)
            
            let label = DateHeaderLabel()
            label.text = dateString
            
            let containerView = UIView()
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            return containerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textMessagesArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        let chatMessage = textMessagesArray[indexPath.section][indexPath.row]
        cell.chatMessage = chatMessage
        return cell
    }
}

extension ChatController: UITextFieldDelegate {
    
    @objc func sendButtonTapped(){
        let text = self.sendTextFiend.text!
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        let selfSender = self.selfSender,
        let messageId = createMessageId() else {
            return
        }
        
        if isNewChat {
            // create chat in db
            let message = ChatMessage(sender: selfSender, messageID: messageId, text: text, isIncoming: false, date: Date())
            DataBaseManager.shared.createNewChat(with: otherUserUid, firstMessage: message) { success in
                if success {
                    print("message send")
                } else {
                    print("failed to send")
                }
            }
        } else {
            // append chat data
        }
        
       
    }
    
    private func createMessageId() -> String? {
        let newId = "\(otherUserUid)_\(selfSender?.uid)"
        
        return newId
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let sectionIndex = textMessagesArray.endIndex
//        let rowIndex = textMessagesArray[sectionIndex-1].endIndex
//        tableView.scrollToRow(at: [sectionIndex-1,rowIndex-1], at: .bottom, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
       
        }
}

// MARK: - SwiftUI
import SwiftUI
struct ChatBotController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // Return whatever controller you want to preview
            let viewController = UINavigationController(rootViewController: ChatController(with: ""))
            return viewController
        }.edgesIgnoringSafeArea(.all)
            
    }
}
