//
//  RMEpisodeController.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 18.01.2023.
//

import UIKit

class RMEpisodeController: UIViewController, RMEpisodeListViewDelegate {

    private var episodeListView = RMEpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setConstraints()
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
    
    private func setupController() {
        view.backgroundColor = .systemBackground
        title = "Episodes"
        view.addSubview(episodeListView)
        episodeListView.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    //MARK: - RMEpisodeListViewDelegate
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        let detailVC = RMEpisodeDetailController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
