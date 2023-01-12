//
//  DownloadImage.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 25.12.2022.
//

import UIKit


extension UIImageView {
    func downloadImage(imageView: UIImageView, url: URL){
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {return}

            DispatchQueue.main.async {
              let image = UIImage(data: data)!
                imageView.image = image
            }
        }).resume()
    }
}
