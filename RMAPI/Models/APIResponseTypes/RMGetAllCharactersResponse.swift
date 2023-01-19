//
//  RMGetAllCharactersResponse.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 19.01.2023.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let preview: String?
    }
    
    let info: Info
    let results: [RMCharacter]
}
