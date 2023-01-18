//
//  RMCharacterController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 18.01.2023.
//

import UIKit

class RMCharacterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        view.backgroundColor = .systemBackground
        title = "Characters"
    }

}
