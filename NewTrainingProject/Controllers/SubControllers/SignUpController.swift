//
//  SignUpController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 15.12.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignUpController: UIViewController {
    
    var nameTextField = DefaultUITextField(placeholderText: "Enter your Name")
    var lastNameTextField = DefaultUITextField(placeholderText: "Enter your LastName")
    var emailTextField = DefaultUITextField(placeholderText: "Enter your Email")
    var passwordTextField = DefaultUITextField(placeholderText: "Enter your Password")
    var signUpButton: UIButton = {
        let button = UIButton()
        button.configuration = .gray()
        button.configuration?.title = "SignUp"
        button.configuration?.baseForegroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var errorLabel = DefaultUILabel(inputText: "Error", fontSize: 18, fontWeight: .regular, alingment: .center)
    var reference: DocumentReference? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setConstraints()
    }

    private func setupController(){
        view.backgroundColor = .white
        [nameTextField, lastNameTextField, emailTextField, passwordTextField, signUpButton, errorLabel].forEach {
            view.addSubview($0)
        }
        signUpButton.addTarget(self, action: #selector(createNewUser), for: .touchUpInside)
        errorLabel.textColor = .red
        errorLabel.alpha = 0
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.size.height/4),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            lastNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            lastNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            lastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            lastNameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            emailTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            signUpButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 10),
            errorLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            errorLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }
    
    @objc func createNewUser(){
        
        let error = ViewControllerHelpers.checkValidSignUp(nameTextField: nameTextField, lastNameTextField: lastNameTextField, emailTextField: emailTextField, passwordTextField: passwordTextField)
        
        if error != nil {
            errorLabel.alpha = 1
            errorLabel.text = error
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if error != nil {
                    self.errorLabel.text = "\(error?.localizedDescription)"
                } else {
                    let dataBase = Firestore.firestore()
                    dataBase.collection("users").addDocument(data: [
                        "name" : self.nameTextField.text!,
                        "lastName" : self.lastNameTextField.text!,
                        "uid" : result!.user.uid
                     ]) { error in
                         if error != nil {
                             self.errorLabel.text = "Error savind user in dataBase"
                         }
                         print("\(result!.user.uid)")
                    }
                    let mainController = UINavigationController(rootViewController: MainController())
                    mainController.modalTransitionStyle = .crossDissolve
                    mainController.modalPresentationStyle = .fullScreen
                    self.present(mainController, animated: true)
                }
            }
        }
    }


}

// MARK: - SwiftUI
import SwiftUI
struct SignUpController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // Return whatever controller you want to preview
            let viewController = SignUpController()
            return viewController
        }.edgesIgnoringSafeArea(.all)
            
    }
}

