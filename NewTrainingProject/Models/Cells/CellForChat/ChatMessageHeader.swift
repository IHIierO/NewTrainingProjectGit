//
//  ChatMessageHeader.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 20.12.2022.
//

import UIKit

class DateHeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green.withAlphaComponent(0.7)
        textColor = .black
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + originalContentSize.height * 0.1
        let width = originalContentSize.width + originalContentSize.width * 0.1
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: width, height: height)
    }
}
