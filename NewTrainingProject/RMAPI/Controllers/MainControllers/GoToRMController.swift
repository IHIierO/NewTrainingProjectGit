//
//  GoToRMController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 12.01.2023.
//

import UIKit

class GoToRMController: UIViewController {
    
    let goButton: UIButton = {
       let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .yellow
        button.configuration?.baseForegroundColor = .black
        button.configuration?.title = "Go to Adventure"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setConstraints()
    }
    
    private func setupController(){
        view.backgroundColor = .systemIndigo
        title = "Go to awesome Adventure"
        view.addSubviews(goButton)
        goButton.addTarget(self, action: #selector(goButtonAction), for: .touchUpInside)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
        
    }
    
    @objc func goButtonAction(){
        let containerController = RMTabbarController()
        containerController.modalTransitionStyle = .crossDissolve
        containerController.modalPresentationStyle = .fullScreen
        present(containerController, animated: true)
    }
}
