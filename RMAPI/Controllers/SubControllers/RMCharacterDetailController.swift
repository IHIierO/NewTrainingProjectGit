//
//  RMCharacterDetailController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 20.01.2023.
//

import UIKit

/// Controller to show info about single Character
final class RMCharacterDetailController: UIViewController {
    
    private var viewModel: RMCharacterDetailViewViewModel
    
    // MARK: - init
    init (viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeStyle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
    }
    
}
