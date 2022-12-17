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
    //MARK: - clearHomeController
    static func clearHomeController(homeController: HomeController){
        if homeController.children.count > 0{
            let viewControllers:[UIViewController] = homeController.children
            viewControllers.last?.willMove(toParent: nil)
            viewControllers.last?.removeFromParent()
            viewControllers.last?.view.removeFromSuperview()
        }
    }
    
    static func chooseController(controller: SideMenuItem, homeController: HomeController){
        
        let settingsController = SettingsController()
        let chatBotController = ChatBotController()
        
        if controller == .settings {
            homeController.addChild(settingsController)
            homeController.view.addSubview(settingsController.view)
            settingsController.view.frame = homeController.view.frame
            settingsController.didMove(toParent: homeController)
            homeController.title = settingsController.title
        } else if controller == .chatBot {
            homeController.addChild(chatBotController)
            homeController.view.addSubview(chatBotController.view)
            chatBotController.view.frame = homeController.view.frame
            chatBotController.didMove(toParent: homeController)
            homeController.title = chatBotController.title
        }
        
    }
}
