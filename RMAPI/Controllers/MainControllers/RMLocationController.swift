//
//  RMLocationController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 18.01.2023.
//

import UIKit

class RMLocationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        addSearchButton()
    }
    
    private func setupController() {
        view.backgroundColor = .systemBackground
        title = "Locations"
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
    
}
