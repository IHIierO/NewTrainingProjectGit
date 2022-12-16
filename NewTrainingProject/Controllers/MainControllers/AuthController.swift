//
//  AuthController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 15.12.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AuthController: UIViewController {
    
    var emailTextField = DefaultUITextField(placeholderText: "Enter your Email")
    var passwordTextField = DefaultUITextField(placeholderText: "Enter your Password")
    var signUpLabel = DefaultUILabel(inputText: "If you have't account,", fontSize: 18, fontWeight: .regular, alingment: .natural)
    var signUpButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.title = "SignUp"
        button.configuration?.baseForegroundColor = .gray
        button.configuration?.contentInsets = .init(top: 0, leading: 2, bottom: 0, trailing: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var authButton: UIButton = {
        let button = UIButton()
        button.configuration = .gray()
        button.configuration?.title = "Authorization"
        button.configuration?.baseForegroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var errorLabel = DefaultUILabel(inputText: "Error mail or password", fontSize: 18, fontWeight: .regular, alingment: .center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setConstraints()
    }

    private func setupController(){
        view.backgroundColor = .white
        [emailTextField, passwordTextField, authButton, errorLabel, signUpLabel, signUpButton].forEach {
            view.addSubview($0)
        }
        signUpButton.addTarget(self, action: #selector(goToSignUpController), for: .touchUpInside)
        authButton.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        errorLabel.textColor = .red
        errorLabel.alpha = 0
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            emailTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            authButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            errorLabel.topAnchor.constraint(equalTo: authButton.bottomAnchor, constant: 10),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signUpLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
            signUpLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            signUpButton.leadingAnchor.constraint(equalTo: signUpLabel.trailingAnchor, constant: 0),
            signUpButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),

        ])
    }
    
    @objc func goToSignUpController(){
        let signUpController = SignUpController()
        self.navigationController?.pushViewController(signUpController, animated: true)
    }
    
    @objc func authenticate(){
        let error = ViewControllerHelpers.checkValidAuth(emailTextField: emailTextField, passwordTextField: passwordTextField)
        
        if error != nil {
            errorLabel.alpha = 1
        }else{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if error != nil {
                    self.errorLabel.alpha = 1
                }else{
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
struct AuthController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // Return whatever controller you want to preview
            let viewController = AuthController()
            return viewController
        }.edgesIgnoringSafeArea(.all)
            
    }
}

