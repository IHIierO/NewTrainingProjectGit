//
//  ContainerController2.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 17.12.2022.
//

import UIKit

class ContainerController: UIViewController {
    
    private let homeController = HomeController()
    private var navController: UINavigationController?
    private var openSideMenuGesture: UISwipeGestureRecognizer?
    private var closeSideMenuGesture: UISwipeGestureRecognizer?
    
    lazy var sideInMenuPadding: CGFloat = self.view.frame.width * 0.3
    var isSideMenuPresented = false
    lazy var menuView = MenuView(with: SideMenuItem.allCases)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerController()
        addChildController()
    }
    
    private func setupContainerController(){
        view.backgroundColor = .systemTeal
        menuView.delegate = self
        menuView.pinMenuTo(view, with: sideInMenuPadding)
        openSideMenuGesture = UISwipeGestureRecognizer(target: self, action: #selector(openSideMenuGestureSwipe(gesture: )))
        openSideMenuGesture?.direction = .right
        closeSideMenuGesture = UISwipeGestureRecognizer(target: self, action: #selector(openSideMenuGestureSwipe(gesture: )))
        closeSideMenuGesture?.direction = .left
        view.addGestureRecognizer(openSideMenuGesture!)
        view.addGestureRecognizer(closeSideMenuGesture!)
    }
    
    private func addChildController(){
        //HomeController
        let navigationHomeController = UINavigationController(rootViewController: homeController)
        addChild(navigationHomeController)
        homeController.delegate = self
        view.addSubview(navigationHomeController.view)
        navigationHomeController.didMove(toParent: self)
        self.navController = navigationHomeController
    }
    
    @objc func openSideMenuGestureSwipe(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .right{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navController?.view.frame.origin.x = self.homeController.view.frame.width - self.sideInMenuPadding
            } completion: { (finished) in
                self.isSideMenuPresented.toggle()
            }
        } else if gesture.direction == .left {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navController?.view.frame.origin.x = 0
            } completion: { (finished) in
                self.isSideMenuPresented.toggle()
            }
        }
    }
}
//MARK: - HomeControllerDelegate
extension ContainerController: HomeControllerDelegate {
    func didTapMenuView() {
        toggleMenu(completion: nil)
    }
    func toggleMenu(completion: (() -> Void)?){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.navController?.view.frame.origin.x = self.isSideMenuPresented ? 0 : self.homeController.view.frame.width - self.sideInMenuPadding
        } completion: { (finished) in
            self.isSideMenuPresented.toggle()
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
//MARK: - MenuViewDelegate
extension ContainerController: MenuViewDelegate {
    func didSelectMenuIdem(named: SideMenuItem) {
        toggleMenu { [self] in
            switch named {
            case .home:
                ViewControllerHelpers.clearHomeController(homeController: homeController)
                homeController.title = "Home"
            case .settings:
                ViewControllerHelpers.clearHomeController(homeController: homeController)
                ViewControllerHelpers.chooseController(controller: .settings, homeController: homeController)
            case .chatBot:
                ViewControllerHelpers.clearHomeController(homeController: homeController)
                ViewControllerHelpers.chooseController(controller: .chatBot, homeController: homeController)
            }
        }
    }
}

// MARK: - SwiftUI
import SwiftUI
struct ContainerController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // Return whatever controller you want to preview
            let viewController = ContainerController()
            return viewController
        }.edgesIgnoringSafeArea(.all)
            
    }
}
