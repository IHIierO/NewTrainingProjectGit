//
//  SettingsController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 16.12.2022.
//

import UIKit

class SettingsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController(){
        view.backgroundColor = .systemCyan
        title = "Settings"
    }
    
}
