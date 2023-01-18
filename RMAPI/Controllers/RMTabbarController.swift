//
//  RMTabbarController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 18.01.2023.
//

import UIKit

class RMTabbarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarConfig()
       // setTabBarAppearance()
    }
    
    private func tabBarConfig(){
        let RMCharacterController = createNavigationControllers(
            viewControllers: RMCharacterController(),
            tabBarItemName: "Characters",
            tabBarItemImage: "person",
            tabBarItemBage: nil,
            tag: 0
        )
        let RMLocationController = createNavigationControllers(
            viewControllers: RMLocationController(),
            tabBarItemName: "Locations",
            tabBarItemImage: "globe",
            tabBarItemBage: nil,
            tag: 1
        )
        let RMEpisodeController = createNavigationControllers(
            viewControllers: RMEpisodeController(),
            tabBarItemName: "Episodes",
            tabBarItemImage: "tv",
            tabBarItemBage: nil,
            tag: 2
        )
        let RMSettingsController = createNavigationControllers(
            viewControllers: RMSettingsController(),
            tabBarItemName: "Settings",
            tabBarItemImage: "gear",
            tabBarItemBage: nil,
            tag: 3
        )
        viewControllers = [RMCharacterController,RMLocationController, RMEpisodeController, RMSettingsController]
        [RMCharacterController,RMLocationController, RMEpisodeController, RMSettingsController].forEach({
            $0.navigationBar.prefersLargeTitles = true
            $0.navigationItem.largeTitleDisplayMode = .automatic
        })
    }
    
    private func createNavigationControllers(viewControllers: UIViewController, tabBarItemName: String, tabBarItemImage: String, tabBarItemBage: String?, tag: Int) -> UINavigationController{
        let tabBarItem = UITabBarItem(title: tabBarItemName, image: UIImage(systemName: tabBarItemImage), tag: tag)
        tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: .zero, bottom: -10, right: .zero)
        tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: 10 )
        tabBarItem.badgeValue = tabBarItemBage
        let navigationController = UINavigationController(rootViewController: viewControllers)
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }
    
    private func setTabBarAppearance(){
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.isTranslucent = true
        
        let customLayer = CAShapeLayer()
        customLayer.path = .init(rect: CGRect(x: 0, y: -10, width: self.tabBar.bounds.width, height: self.tabBar.bounds.height * 2), transform: .none)
        tabBar.layer.insertSublayer(customLayer, at: 0)
        customLayer.fillColor = UIColor(hexString: "#FDFAF3").cgColor
        customLayer.shadowRadius = 3
        customLayer.shadowOpacity = 0.8
        customLayer.shadowOffset = .zero
        customLayer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        tabBar.tintColor = UIColor(hexString: "#324B3A")
        tabBar.unselectedItemTintColor = UIColor(hexString: "#393C39")
    }
    
    func hideTabBar() {
        self.tabBar.isHidden = true
    }
    func showTabBar() {
        self.tabBar.isHidden = false
    }
//    func changeBageValue(){
//        if let tabBarItems = self.tabBar.items{
//            let i = tabBarItems[2]
//            i.badgeValue = Persons.ksenia.productsInCart.count > 0 ? "\(Persons.ksenia.productsInCart.count)" : nil
//        }
//    }
}
