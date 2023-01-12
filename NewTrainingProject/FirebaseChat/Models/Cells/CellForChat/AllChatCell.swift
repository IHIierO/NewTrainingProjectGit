//
//  AllChatCell.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 25.12.2022.
//

import UIKit

class AllChatCell: UITableViewCell {
    
    static let id = "AllChatCell"
    
    lazy var width: CGFloat = frame.width * 0.3
    
    lazy var userAvatar: UIImageView = {
        let userAvatar = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        userAvatar.layer.cornerRadius = userAvatar.frame.width / 2
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.layer.masksToBounds = true
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        return userAvatar
    }()
    
    lazy var userNameLabel = DefaultUILabel(inputText: "", fontSize: 21, fontWeight: .semibold, alingment: .left)
    lazy var userMessageLabel = DefaultUILabel(inputText: "", fontSize: 19, fontWeight: .regular, alingment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        userMessageLabel.numberOfLines = 0
        [userAvatar, userNameLabel, userMessageLabel].forEach({
            addSubview($0)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            userAvatar.centerYAnchor.constraint(equalTo: centerYAnchor),
            userAvatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userAvatar.widthAnchor.constraint(equalToConstant: width),
            userAvatar.heightAnchor.constraint(equalToConstant: width),
            
            userNameLabel.topAnchor.constraint(equalTo: userAvatar.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            
            userMessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            userMessageLabel.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 20),
            userMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    public func configure(with model: Chats) {
        userMessageLabel.text = model.latestMessage.text
        userNameLabel.text = model.name
        let activituIndicator = DefaultActivityIndicator(indicatorStyle: .medium)
        activituIndicator.show(view: userAvatar)
        let path = "images/\(model.otherUserId)_profile_image.png"
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            switch result {
            case .success(let url):
                activituIndicator.remove()
                self?.userAvatar.downloadImage(imageView: self!.userAvatar, url: url)
            case .failure(let error):
                print("Failed to get download URL: \(error)")
            }
        }
    }
    
}
