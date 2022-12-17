//
//  ChatBotController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 17.12.2022.
//

import UIKit

class ChatBotController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController(){
        view.backgroundColor = .systemMint
        title = "ChatBot"
    }
    
}
