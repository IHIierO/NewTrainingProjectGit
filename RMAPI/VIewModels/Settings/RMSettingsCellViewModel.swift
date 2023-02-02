//
//  RMSettingsCellViewModel.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 31.01.2023.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    
    let id = UUID()
    
    // MARK: - Init
    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption) -> Void
    
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    // MARK: - Public
    
    public var image: UIImage? {
        return type.displayImage
    }
    public var title: String {
        return type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
}
