//
//  RMLocationDetailController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 15.02.2023.
//

import UIKit

final class RMLocationDetailController: UIViewController, RMLocationDetailViewViewModelDelegate, RMLocationDetailViewDelegate {
    
    private let viewModel: RMLocationDetailViewViewModel
    private let detailView = RMLocationDetailView()
    
    // MARK: - Init
    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endpointUrl: url)
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
        title = "Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare))
        detailView.delegate = self
        viewModel.delegate = self
        viewModel.fetchLocationData()
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
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
    
    func rmEpisodeDetailView(
        _ detailView: RMLocationDetailView,
        didSelect character: RMCharacter
    ) {
        let viewController = RMCharacterDetailController(viewModel: .init(character: character))
        viewController.title = character.name
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}
