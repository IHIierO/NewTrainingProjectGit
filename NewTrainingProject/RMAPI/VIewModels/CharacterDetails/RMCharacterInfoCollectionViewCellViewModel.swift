//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 23.01.2023.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    private let type: `Type`
    private let value: String
    
    static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    public var title: String {
        self.type.displayTitle
    }
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var displayValue: String {
        if value.isEmpty {
            return "None"
        }
        
        if let date = Self.dateFormatter.date(from: value),
           type == .created {
            return CustomDate.rmShortDateFormatter(from: date)
        }
        return value
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemRed
            case .gender:
                return .systemBlue
            case .type:
                return .systemCyan
            case .species:
                return .systemGreen
            case .origin:
                return .systemYellow
            case .created:
                return .systemMint
            case .location:
                return .systemOrange
            case .episodeCount:
                return .systemPink
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "globe")
            case .gender:
                return UIImage(systemName: "globe")
            case .type:
                return UIImage(systemName: "globe")
            case .species:
                return UIImage(systemName: "globe")
            case .origin:
                return UIImage(systemName: "globe")
            case .created:
                return UIImage(systemName: "globe")
            case .location:
                return UIImage(systemName: "globe")
            case .episodeCount:
                return UIImage(systemName: "globe")
            }
        }
        
        var displayTitle: String {
            switch self {
            case .status,
                    .gender,
                    .type,
                    .species,
                    .origin,
                    .created,
                    .location:
                return rawValue.uppercased()
            case .episodeCount:
                return "EPISODE COUNT"
            }
        }
    }
    
    init(type: `Type`, value: String) {
        self.value = value
        self.type = type
    }
}
