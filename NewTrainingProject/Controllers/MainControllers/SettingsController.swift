//
//  SettingsController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 16.12.2022.
//

import UIKit

class SettingsController: UIViewController, MenuViewDelegate {
    
    lazy var sideMenuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(sideMenuBarButtonItemTapped))
    lazy var sideInMenuPadding: CGFloat = self.view.frame.width * 0.3
    var isSideMenuPresented = false
    lazy var menuView = MenuView(with: SideMenuItem.allCases)
    lazy var containerView: UIView = {
       let container = UIView()
        container.backgroundColor = .systemTeal
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController(){
        view.backgroundColor = .systemTeal
        title = "Settings"
        navigationItem.setLeftBarButton(sideMenuBarButtonItem, animated: false)
        menuView.delegate = self
        menuView.pinMenuTo(view, tith: sideInMenuPadding)
        containerView.edgeTo(view)
    }
    
   func presentAnimate2() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.containerView.frame.origin.x = self.isSideMenuPresented ? 0 : self.containerView.frame.width - self.sideInMenuPadding
        }
    }
    
    @objc func sideMenuBarButtonItemTapped(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.containerView.frame.origin.x = self.isSideMenuPresented ? 0 : self.containerView.frame.width - self.sideInMenuPadding
        } completion: { (finished) in
            self.isSideMenuPresented.toggle()
        }
    }
    
    func didSelectMenuIdem(named: SideMenuItem) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.containerView.frame.origin.x = self.isSideMenuPresented ? 0 : self.containerView.frame.width - self.sideInMenuPadding
        } completion: { (finished) in
            self.isSideMenuPresented.toggle()
        }
        
        switch named {
        case .home:
            print("\(named)")
            let mainController = UINavigationController(rootViewController: MainController()) 
            mainController.modalTransitionStyle = .crossDissolve
            mainController.modalPresentationStyle = .overFullScreen
            present(mainController, animated: true)
        case .settings:
            print("\(named)")
            
        case .chatBot:
            print("\(named)")
        }
    }
    
}
