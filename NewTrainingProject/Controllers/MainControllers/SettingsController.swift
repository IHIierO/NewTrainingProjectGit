//
//  SettingsController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 16.12.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SettingsController: UIViewController {
    
    var signOutButton: UIButton = {
        let button = UIButton()
        button.configuration = .gray()
        button.configuration?.title = "SignOut"
        button.configuration?.baseForegroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setConstraints()
    }
    
    private func setupController(){
        view.backgroundColor = .systemCyan
        title = "Settings"
        view.addSubview(signOutButton)
        signOutButton.addTarget(self, action: #selector(signOutButtonAction), for: .touchUpInside)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            signOutButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            
        ])
    }
    
    @objc func signOutButtonAction(){
        let firebaseAuth = Auth.auth()
     do {
       try firebaseAuth.signOut()
         let authController = AuthController()
         authController.modalTransitionStyle = .crossDissolve
         authController.modalPresentationStyle = .fullScreen
         self.present(authController, animated: true)
     } catch let signOutError as NSError {
       print("Error signing out: %@", signOutError)
     }
    }
    
}
