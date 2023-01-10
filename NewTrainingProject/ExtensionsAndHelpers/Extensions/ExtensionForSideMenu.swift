//
//  ExtensionForSideMenu.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 16.12.2022.
//

import UIKit

public extension UIView {
    func edgeTo(_ view: UIView){
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func pinMenuTo(_ view: UIView, with constant: CGFloat){
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

protocol MenuViewDelegate {
    func didSelectMenuItem(named: SideMenuItem)
}

extension UIViewController {
    func presentAnimate(containerView: UIView, isSideMenuPresented: Bool, sideInMenuPadding: CGFloat){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                    containerView.frame.origin.x = isSideMenuPresented ? 0 : containerView.frame.width - sideInMenuPadding
                }
    }
}
