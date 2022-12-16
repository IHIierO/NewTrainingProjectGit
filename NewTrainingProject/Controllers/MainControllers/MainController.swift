//
//  MainController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 15.12.2022.
//

import UIKit

class MainController: UIViewController, MenuViewDelegate {
    
    lazy var sideMenuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(sideMenuBarButtonItemTapped))
    lazy var sideInMenuPadding: CGFloat = self.view.frame.width * 0.3
    var isSideMenuPresented = false
    lazy var menuView = MenuView(with: SideMenuItem.allCases)
    lazy var containerView: UIView = {
       let container = UIView()
        container.backgroundColor = .systemTeal
        return container
    }()
    
    private let settingsController = SettingsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
       // addChildController()
    }
    
    private func setupController(){
        view.backgroundColor = .systemTeal
        title = "Main"
        navigationItem.setLeftBarButton(sideMenuBarButtonItem, animated: false)
        menuView.delegate = self
        menuView.pinMenuTo(view, tith: sideInMenuPadding)
        containerView.edgeTo(view)
        
    }
    
    private func addChildController(){
        addChild(settingsController)
        
        view.addSubview(settingsController.view)
        
        settingsController.view.frame = view.bounds
        
        settingsController.didMove(toParent: self)
        
        settingsController.view.isHidden = true
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
        case .settings:
            print("\(named)")
            
            let settingsController = UINavigationController(rootViewController: SettingsController())
            settingsController.modalTransitionStyle = .crossDissolve
            settingsController.modalPresentationStyle = .overFullScreen
            present(settingsController, animated: true)
        case .chatBot:
            print("\(named)")
        }
    }
    
}

// MARK: - SwiftUI
import SwiftUI
struct MainController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // Return whatever controller you want to preview
            let viewController = UINavigationController(rootViewController:  MainController())
            return viewController
        }.edgesIgnoringSafeArea(.all)
            
    }
}
