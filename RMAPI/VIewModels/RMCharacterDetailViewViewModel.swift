//
//  RMCharacterDetailViewViewModel.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 20.01.2023.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    
    private var character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
