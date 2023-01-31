//
//  RMEpisodeDetailView.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 27.01.2023.
//

import UIKit

protocol RMEpisodeDetailViewDelegate: AnyObject {
    func rmEpisodeDetailView(
        _ detailView: RMEpisodeDetailView,
        didSelect character: RMCharacter
    )
}

final class RMEpisodeDetailView: UIView {
    
    weak var delegate: RMEpisodeDetailViewDelegate?
    
    private var viewModel: RMEpisodeDetailViewViewModel? {
        didSet {
            spinner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView?.alpha = 1
            }
        }
    }
    
    private var collectionView: UICollectionView?
    private let spinner = DefaultActivityIndicator(indicatorStyle: .large)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        spinner.hidesWhenStopped = true
        addSubviews(collectionView, spinner)
        self.collectionView = collectionView
        spinner.startAnimating()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    public func configure(with viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSections(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isEditing = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }
   
    private func createSections(for sectionIndex: Int) -> NSCollectionLayoutSection {
        
        guard let sectionType = viewModel?.cellViewModels else {
            return createInfoSectionLayout()
        }
        switch sectionType[sectionIndex] {
        case .information:
            return createInfoSectionLayout()
        case .characters:
            return createCharacterSectionLayout()
        }
    }
}

// MARK: - Layout
extension RMEpisodeDetailView {
    
    public func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = CreateSection.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), contentInsets: .init(top: 0, leading: 0, bottom: 10, trailing: 0))
        let group = CreateSection.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalHeight(0.1), item: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createCharacterSectionLayout() -> NSCollectionLayoutSection {
        let item = CreateSection.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), contentInsets: .init(top: 5, leading: 10, bottom: 5, trailing: 10))
        let group = CreateSection.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.3), item: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RMEpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else {
            return 0
        }
        let sectionType = sections[section]
        switch sectionType {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let sections = viewModel?.cellViewModels else {
            fatalError("No viewModel")
        }
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .information(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier, for: indexPath) as? RMEpisodeInfoCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        case .characters(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = viewModel else {
            return
        }
        let sections = viewModel.cellViewModels
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .information:
            break
        case .characters(let viewModels):
            guard let character = viewModel.character(at: indexPath.row) else {
                return
            }
            delegate?.rmEpisodeDetailView(self, didSelect: character)
        }
    }
    
}
