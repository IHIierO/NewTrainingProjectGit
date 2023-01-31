//
//  RMEpisodeDetailController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 25.01.2023.
//

import UIKit

/// Controller to show details about single episode
final class RMEpisodeDetailController: UIViewController, RMEpisodeDetailViewViewModelDelegate, RMEpisodeDetailViewDelegate {
    
    private let viewModel: RMEpisodeDetailViewViewModel
    private let detailView = RMEpisodeDetailView()
    
    // MARK: - Init
    init(url: URL?) {
        self.viewModel = RMEpisodeDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setConstraints()
    }
    
    private func setupController() {
        view.addSubview(detailView)
        view.backgroundColor = .systemBackground
        title = "Episode"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare))
        detailView.delegate = self
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }
    
    @objc func didTapShare() {
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Delegate
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
    
    func rmEpisodeDetailView(
        _ detailView: RMEpisodeDetailView,
        didSelect character: RMCharacter
    ) {
        let viewController = RMCharacterDetailController(viewModel: .init(character: character))
        viewController.title = character.name
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}
