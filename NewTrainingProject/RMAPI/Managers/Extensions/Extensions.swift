//
//  Extensions.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 19.01.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
