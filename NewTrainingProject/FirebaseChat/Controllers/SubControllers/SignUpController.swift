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
import Photos
import PhotosUI

class SignUpController: UIViewController {
    
    let width = UIScreen.main.bounds.width
    var profileImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var firstNameTextField = DefaultUITextField(placeholderText: "Enter your Name")
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
        setupProfileImage()
        setConstraints()
    }

    private func setupController(){
        view.backgroundColor = .white
        [profileImage,firstNameTextField, lastNameTextField, emailTextField, passwordTextField, signUpButton, errorLabel].forEach {
            view.addSubview($0)
        }
        signUpButton.addTarget(self, action: #selector(createNewUser), for: .touchUpInside)
        errorLabel.textColor = .red
        errorLabel.alpha = 0
        passwordTextField.isSecureTextEntry = true
    }
    
    private func setupProfileImage(){
        profileImage.layer.cornerRadius = width * 0.5 / 2
        profileImage.layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapProfileImafeToChange))
        profileImage.addGestureRecognizer(gesture)
    }
    
    @objc func tapProfileImafeToChange(){
        presentPhotoActionSheet()
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            profileImage.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstNameTextField.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            firstNameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 10),
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
        
        let error = ViewControllerHelpers.checkValidSignUp(nameTextField: firstNameTextField, lastNameTextField: lastNameTextField, emailTextField: emailTextField, passwordTextField: passwordTextField)
        
        if error != nil {
            errorLabel.alpha = 1
            errorLabel.text = error
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!.lowercased(), password: passwordTextField.text!) { [weak self] result, error in
                guard let strongSelf = self else {return}
                if error != nil {
                    strongSelf.errorLabel.text = "\(error?.localizedDescription ?? "Some error")"
                } else {
                    DataBaseManager.shared.saveNewUser(users: ChatUsers(firstName: strongSelf.firstNameTextField.text!, lastName: strongSelf.lastNameTextField.text!, email: strongSelf.emailTextField.text!, uid: (result?.user.uid)!), errorLabel: strongSelf.errorLabel)
                    
                    guard let image = strongSelf.profileImage.image, let data = image.pngData() else {
                        return
                    }
                    let fileName = "\(result!.user.uid)_profile_image.png"
                    StorageManager.shared.uploadProfileImage(with: data, fileName: fileName) { results in
                        switch results {
                        case .success(let downloadURL):
                            UserDefaults.standard.set(downloadURL, forKey: "profile_image_url")
                            print(downloadURL)
                        case .failure(let error):
                            print("Storage manager error: \(error)")
                        }
                    }
                    if Auth.auth().currentUser != nil {
                        let containerController = ContainerController()
                        containerController.modalTransitionStyle = .crossDissolve
                        containerController.modalPresentationStyle = .fullScreen
                        strongSelf.present(containerController, animated: true)
                    }
                }
            }
        }
    }
}

extension SignUpController: UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Фото профиля", message: "Выберете способ", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Библиотека", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        profileImage.image = image
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let image = reading as? UIImage, error == nil else {return}
                DispatchQueue.main.async {
                    self?.profileImage.image = image
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


// MARK: - SwiftUI
//import SwiftUI
//struct SignUpController_Previews: PreviewProvider {
//    static var previews: some View {
//        UIViewControllerPreview {
//            // Return whatever controller you want to preview
//            let viewController = SignUpController()
//            return viewController
//        }.edgesIgnoringSafeArea(.all)
//            
//    }
//}

