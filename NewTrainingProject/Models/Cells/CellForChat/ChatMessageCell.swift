//
//  ChatMessageCell.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 20.12.2022.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let chatBackgroundView = UIView()
    let padding = UIScreen.main.bounds.width * 0.04
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var chatMessage: ChatMessage! {
        didSet {
            chatBackgroundView.backgroundColor = chatMessage.isIncoming ? .white : .lightGray
            messageLabel.textColor = chatMessage.isIncoming ? .black : .white
            
            messageLabel.text = chatMessage.text
            
            if chatMessage.isIncoming {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(chatBackgroundView)
        chatBackgroundView.backgroundColor = .white
        chatBackgroundView.layer.cornerRadius = 8
        chatBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            chatBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -padding/2),
            chatBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -padding/2),
            chatBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: padding/2),
            chatBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: padding/2),
        ])
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
