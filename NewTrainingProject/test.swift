//
//  test.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 15.12.2022.
//

import UIKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }


}

// MARK: - SwiftUI
import SwiftUI
struct ViewController2_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            // Return whatever controller you want to preview
            let viewController = ViewController2()
            return viewController
        }.edgesIgnoringSafeArea(.all)
            
    }
}

