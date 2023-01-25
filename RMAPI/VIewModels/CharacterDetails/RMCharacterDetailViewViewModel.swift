//
//  RMCharacterDetailViewViewModel.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 20.01.2023.
//

import UIKit

final class RMCharacterDetailViewViewModel {
    
    private var character: RMCharacter
    
    public var episodes: [String] {
        character.episode
    }
    
    enum SectionType {
        case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel)
        
        case information(viewModels: [RMCharacterInfoCollectionViewCellViewModel])
        
        case episodes(viewModels: [RMCharacterEpisodeCollectionViewCellViewModel])
    }
    
    public var sections: [SectionType] = []
    
    // MARK: - Init
    init(character: RMCharacter) {
        self.character = character
        setupSections()
    }
    
    private func setupSections() {
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: character.image))),
            .information(viewModels: [
                .init(type: .status ,value: character.status.text),
                .init(type: .gender ,value: character.gender.rawValue),
                .init(type: .type ,value: character.type),
                .init(type: .species ,value: character.species),
                .init(type: .origin ,value: character.origin.name),
                .init(type: .location ,value: character.location.name),
                .init(type: .created ,value: character.created),
                .init(type: .episodeCount ,value: "\(character.episode.count)"),
            ]),
            .episodes(viewModels: character.episode.compactMap ({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            }))
        ]
    }
    
    private var requestURL: URL? {
        return URL(string: character.url)
    }
    
    public var title: String {
        character.name.uppercased()
    }
    
    // MARK: - Layouts
    
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = CreateSection.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), contentInsets: .init(top: 0, leading: 0, bottom: 10, trailing: 0))
        let group = CreateSection.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalHeight(0.5), item: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createInformationSectionLayout() -> NSCollectionLayoutSection {
        let item = CreateSection.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), contentInsets: .init(top: 2, leading: 2, bottom: 2, trailing: 2))
        let group = CreateSection.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.33), item: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
        let item = CreateSection.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), contentInsets: .init(top: 10, leading: 5, bottom: 10, trailing: 8))
        let group = CreateSection.createGroup(alignment: .horizontal, width: .fractionalWidth(0.8), height: .fractionalWidth(0.3), item: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
}
