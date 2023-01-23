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
    
    let detailview: RMCharacterDetailView
    
    // MARK: - init
    init (viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailview = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeStyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setConstraints()
    }
    
    private func setupController() {
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(detailview)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare))
        detailview.collectionView?.delegate = self
        detailview.collectionView?.dataSource = self
    }
    
    @objc func didTapShare() {
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            detailview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailview.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - CollectionView
extension RMCharacterDetailController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 8
        case 2: return 10
        default: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemPink
        return cell
    }
}
