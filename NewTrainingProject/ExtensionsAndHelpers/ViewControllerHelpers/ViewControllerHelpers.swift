//
//  ViewControllerHelpers.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 15.12.2022.
//

import UIKit

class ViewControllerHelpers {
    //MARK: - checkValidSignUp
    static func checkValidSignUp(nameTextField: DefaultUITextField, lastNameTextField: DefaultUITextField, emailTextField: DefaultUITextField, passwordTextField: DefaultUITextField) -> String?{
        if nameTextField.text == "" ||
            lastNameTextField.text == "" ||
            emailTextField.text == "" ||
            passwordTextField.text == "" ||
            nameTextField.text == nil ||
            lastNameTextField.text == nil ||
            emailTextField.text == nil ||
            passwordTextField.text == nil {
            
            return "Please fill in all fiels"
        }
        
        return nil
    }
    //MARK: - checkValidAuth
    static func checkValidAuth(emailTextField: DefaultUITextField, passwordTextField: DefaultUITextField) -> String?{
        if emailTextField.text == "" ||
            passwordTextField.text == "" ||
            emailTextField.text == nil ||
            passwordTextField.text == nil {
            
            return "Please fill in all fiels"
        }
        
        return nil
    }
    
   
}
