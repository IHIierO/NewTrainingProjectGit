//
//  ChatModels.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 20.12.2022.
//

import UIKit

struct ChatMessage {
    var sender: Sender
    var messageID: String
    let text: String
    let isIncoming: Bool
    let date: Date
}

struct ChatUsers {
    let firstName: String
    let lastName: String
    let email: String
    let uid: String
    // let profilePictureURL: String
}

struct Sender {
    var photoURL: String
    var senderId: String
    var displayName: String
}
