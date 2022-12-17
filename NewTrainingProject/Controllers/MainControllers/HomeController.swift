//
//  MainController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 15.12.2022.
//

import UIKit

protocol HomeControllerDelegate: AnyObject {
    func didTapMenuView()
}

class HomeController: UIViewController{
    
    weak var delegate: HomeControllerDelegate?
    
    lazy var sideMenuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(sideMenuBarButtonItemTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController(){
        view.backgroundColor = .systemTeal
        title = "Home"
        navigationItem.setLeftBarButton(sideMenuBarButtonItem, animated: false)
    }
    
    @objc func sideMenuBarButtonItemTapped(){
        delegate?.didTapMenuView()
    }
    
}

// MARK: - SwiftUI
import SwiftUI
struct MainController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // Return whatever controller you want to preview
            let viewController = UINavigationController(rootViewController:  HomeController())
            return viewController
        }.edgesIgnoringSafeArea(.all)
            
    }
}
