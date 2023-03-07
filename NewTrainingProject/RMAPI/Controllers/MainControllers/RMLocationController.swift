//
//  RMLocationController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 18.01.2023.
//

import UIKit

class RMLocationController: UIViewController, RMLocationViewViewModelDelegate, RMLocationViewDelegate {
    
    private let locationView = RMLocationView()
    
    private let viewModel = RMLocationViewViewModel()
    
// MARK: - LifeStyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setConstraints()
        addSearchButton()
    }
    
    private func setupController() {
        view.backgroundColor = .systemBackground
        title = "Locations"
        view.addSubview(locationView)
        locationView.delegate = self
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            locationView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            locationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let searchController = RMSearchController(config: .init(type: .location))
        searchController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    // MARK: - RMLocationViewDelegate
    
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let detailVC = RMLocationDetailController(location: location)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - RMLocationViewModelDelegate
    func didFetchInitialLocations() {
        locationView.config(with: viewModel)
    }
}
