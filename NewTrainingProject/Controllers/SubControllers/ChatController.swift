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
    public var chatUid: String?
    public var isNewChat = false
    lazy var displayName: String = ""
    
    private var selfSender: Sender? {
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            let userId = user.uid
            
            DataBaseManager.shared.getUserName(user: user){[weak self] result in
                switch result {
                case .success(let userName):
                    self?.displayName = userName
                case .failure(let error):
                    print("Failed to get User Name: \(error)")
                }
            }
            
          return Sender(photoURL: "", senderId: userId, displayName: displayName)
        }
        
        return nil
    }
    
    
    var textMessagesArray = [ChatMessage]()
    var messageFromServer = [[ChatMessage]]()
    private func attemptToAssambleGroupedMessage(){
        let groupedMessage = Dictionary(grouping: textMessagesArray) { message -> Date in
            let string = CustomDate.dateString(date: message.date)
            let date = CustomDate.dateFromCustomString(string: string)
            return date
        }

        let sortedKeys = groupedMessage.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedMessage[key]
            messageFromServer.append(values ?? [])
        }
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
    
    init(with uid: String, id: String?){
        self.chatUid = id
        self.otherUserUid = uid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setConstraints()
        registerObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let chatUid = chatUid {
           listenForMessage(id: chatUid)
        } 
    }
    
    deinit{
        removeObservers()
    }
    
    private func setupController(){
        
        BackButton(vc: self).createBackButton()
        view.backgroundColor = .systemMint
        view.addSubview(sendTextFiend)
        sendTextFiend.delegate = self
        sendTextFiend.becomeFirstResponder()
        view.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        tableView.separatorStyle = .none
    }
    
    private func setConstraints(){
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
    private func registerObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            UIView.animate(withDuration: 0, delay: 0) { [weak self] in
                let keyboardHeight = keyboardFrame.cgRectValue.height
                let offsetHeight = keyboardHeight + (self?.sendTextFiend.frame.size.height)!
                self?.tableView.contentOffset = CGPoint(x: 0, y: offsetHeight)
                if !(self?.messageFromServer.isEmpty)! {
                    let section = (self?.messageFromServer.count ?? 1) - 1
                    let row = (self?.messageFromServer[section].count ?? 1) - 1
                    let indexPath = IndexPath(row: row, section: section)
                    self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(){
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            self?.tableView.setContentOffset(CGPoint.zero, animated: false)
            if !(self?.messageFromServer.isEmpty)! {
                let section = (self?.messageFromServer.count ?? 1) - 1
                let row = (self?.messageFromServer[section].count ?? 1) - 1
                let indexPath = IndexPath(row: row, section: section)
                self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
   
    //MARK: - listenForMessage
    private func listenForMessage(id: String){
        DataBaseManager.shared.getAllMessagesForChat(with: id, forSender: self.selfSender!) {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                self?.textMessagesArray = messages
                self?.messageFromServer.removeAll()
                self?.attemptToAssambleGroupedMessage()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    let section = strongSelf.messageFromServer.count - 1
                    let row = strongSelf.messageFromServer[section].count - 1
                    let indexPath = IndexPath(row: row, section: section)
                    self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            case .failure(let error):
                print("Failed to get messages: \(error)")
            }
        }
    }
     
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messageFromServer.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = messageFromServer[section].first {
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
        return messageFromServer[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        let chatMessage = messageFromServer[indexPath.section].sorted(by: {$0.date < $1.date})[indexPath.row]
        cell.chatMessage = chatMessage
        return cell
    }
}
//MARK: - sendButtonTapped
extension ChatController: UITextFieldDelegate {
    
    @objc func sendButtonTapped(){
        let text = sendTextFiend.text!
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        let selfSender = self.selfSender,
        let messageId = createMessageId() else {
            return
        }
        let message = ChatMessage(sender: selfSender, messageID: messageId, text: text, isIncoming: false, date: Date())
        if isNewChat {
            // create chat in db
            guard let name = title else {
                return
            }
            DataBaseManager.shared.createNewChat(with: otherUserUid, name: name, firstMessage: message) { [weak self] success in
                if success {
                    print("message send")
                    self?.isNewChat = false
                    self?.sendTextFiend.text?.removeAll()
                    let newChatId = "chat_\(message.messageID)"
                    self?.chatUid = newChatId
                    self?.listenForMessage(id: newChatId)
                } else {
                    print("failed to send")
                }
            }
        } else {
            guard let chatUid = chatUid, let name = title else {
                return
            }
            // append chat data
            DataBaseManager.shared.sendMessage(to: chatUid, otherUserUid: otherUserUid, name: name, message: message) {[weak self] success in
                if success {
                    self?.sendTextFiend.text?.removeAll()
                    self?.listenForMessage(id: chatUid)
                    
                    print("message send")
                } else {
                    print("failed to send")
                }
            }
        }
    }
    
    private func createMessageId() -> String? {
        let newId = "\(otherUserUid)_\(selfSender!.senderId)_\(Date())"
        
        return newId
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
        }
}

// MARK: - SwiftUI
//import SwiftUI
//struct ChatBotController_Previews: PreviewProvider {
//    static var previews: some View {
//        UIViewControllerPreview {
//            // Return whatever controller you want to preview
//            let viewController = UINavigationController(rootViewController: ChatController(with: "", id: ""))
//            return viewController
//        }.edgesIgnoringSafeArea(.all)
//            
//    }
//}
