//
//  DefaultUIClasses.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 15.12.2022.
//

import UIKit

//MARK: - DefaultUITextField
class DefaultUITextField: UITextField {
    
    var placeholderText: String
    
    init(placeholderText: String){
        self.placeholderText = placeholderText
        super.init(frame: .zero)
        
        self.placeholder = placeholderText
        self.borderStyle = .roundedRect
        self.enablesReturnKeyAutomatically = true
       // self.backgroundColor = .clear
       // self.textColor = UIColor(hexString: "#324B3A")
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updatePlaceholder(newPlaceholderText: String){
        self.placeholder = newPlaceholderText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - DefaultUILabel
class DefaultUILabel: UILabel {
    
    let inputText: String
    let fontSize: CGFloat
    let fontWeight: UIFont.Weight
    let alingment: NSTextAlignment
    
    init(inputText: String, fontSize: CGFloat, fontWeight: UIFont.Weight, alingment: NSTextAlignment){
        self.inputText = inputText
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.alingment = alingment
        super.init(frame: .zero)
        self.text = inputText
        self.textAlignment = alingment
        self.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
