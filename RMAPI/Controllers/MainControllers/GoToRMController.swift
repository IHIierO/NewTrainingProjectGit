//
//  GoToRMController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 12.01.2023.
//

import UIKit

class GoToRMController: UIViewController {
    
    let backButton: UIButton = {
       let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .yellow
        button.configuration?.baseForegroundColor = .black
        button.configuration?.title = "Back to Chat app"
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
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    @objc func backButtonAction(){
        let containerController = ContainerController()
        containerController.modalTransitionStyle = .crossDissolve
        containerController.modalPresentationStyle = .fullScreen
        present(containerController, animated: true)
    }
}
