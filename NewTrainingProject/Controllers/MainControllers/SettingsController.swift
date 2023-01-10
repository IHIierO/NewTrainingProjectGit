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
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            signOutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            signOutButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
        ])
    }
    
    @objc func signOutButtonAction(){
        let firebaseAuth = Auth.auth()
     do {
       try firebaseAuth.signOut()
         let authController = UINavigationController(rootViewController: AuthController()) 
         authController.modalTransitionStyle = .crossDissolve
         authController.modalPresentationStyle = .fullScreen
         present(authController, animated: true)
     } catch let signOutError as NSError {
       print("Error signing out: %@", signOutError)
     }
    }
}

// MARK: - SwiftUI
//import SwiftUI
//struct SettingsController_Previews: PreviewProvider {
//    static var previews: some View {
//        UIViewControllerPreview {
//            // Return whatever controller you want to preview
//            let viewController = UINavigationController(rootViewController: SettingsController())
//            return viewController
//        }.edgesIgnoringSafeArea(.all)
//            
//    }
//}
