//
//  ChatController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 17.12.2022.
//

import UIKit

class ChatController: UITableViewController {
    
    var textMessagesArray = [[ChatMessage]]()
    var messageFromServer = [
        ChatMessage(text: "Привет", isIncoming: true, date: Date.dateFromCustomString(string: "19.12.2022")) ,
        ChatMessage(text: "Чем сегодня занимался?", isIncoming: true, date: Date.dateFromCustomString(string: "19.12.2022")),
        ChatMessage(text: "Привет, да ничем особенным. Программировал пол дня, покушал. Посмотрел видосы.", isIncoming: false, date: Date.dateFromCustomString(string: "20.12.2022")),
        ChatMessage(text: "У тебя как дела?", isIncoming: false, date: Date.dateFromCustomString(string: "20.12.2022")),
        ChatMessage(text: "Да у меня ничего особенного, как обычно одна работа(", isIncoming: true, date: Date.dateFromCustomString(string: "20.12.2022"))
    ]
    private func attemptToAssambleGroupedMessage(){
        let groupedMessage = Dictionary(grouping: messageFromServer) { message -> Date in
            return message.date
        }
        
        let sortedKeys = groupedMessage.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedMessage[key]
            textMessagesArray.append(values ?? [])
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController(){
        attemptToAssambleGroupedMessage()
        view.backgroundColor = .systemMint
        title = "Chat"
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        tableView.separatorStyle = .none
        view.addSubview(sendTextFiend)
        sendTextFiend.delegate = self
        view.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            sendTextFiend.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            sendTextFiend.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sendTextFiend.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            sendTextFiend.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            
            sendButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            sendButton.leadingAnchor.constraint(equalTo: sendTextFiend.trailingAnchor, constant: 10),
            sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            sendButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
        ])
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return textMessagesArray.count
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textMessagesArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        let chatMessage = textMessagesArray[indexPath.section][indexPath.row]
        cell.chatMessage = chatMessage
        return cell
    }
}
extension ChatController: UITextFieldDelegate {
    
    @objc func sendButtonTapped(){
        let text = self.sendTextFiend.text
        if !text!.isEmpty {
            let sendDate = Calendar.current.dateComponents([.day, .month, .year], from: .now)
            let date = Calendar.current.date(from: sendDate)
            messageFromServer.append(contentsOf: [ChatMessage(text: text!, isIncoming: false, date: date!)])
            attemptToAssambleGroupedMessage()
            tableView.reloadData()
            sendTextFiend.text = nil
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return tableView.endEditing(true)
       
        }
}

// MARK: - SwiftUI
import SwiftUI
struct ChatBotController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // Return whatever controller you want to preview
            let viewController = UINavigationController(rootViewController: ChatController())
            return viewController
        }.edgesIgnoringSafeArea(.all)
            
    }
}
