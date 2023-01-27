//
//  RMEpisodeDetailController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 25.01.2023.
//

import UIKit

/// Controller to show details about single episode
final class RMEpisodeDetailController: UIViewController {
    
    private let viewModel: RMEpisodeDetailViewViewModel
    
    // MARK: - Init
    init(url: URL?) {
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episode"
    }
}
