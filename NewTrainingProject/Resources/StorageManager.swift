//
//  StorageManager.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 21.12.2022.
//

import UIKit
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public func uploadProfileImage(with data: Data, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { [weak self] metadata, error in
            guard let strongSelf = self else {return}
            guard error == nil else {
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            strongSelf.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(StorageErrors.failedToGetDowloadUrl))
                    return
                }
                let urlString = url.absoluteString
                completion(.success(urlString))
            }
        }
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDowloadUrl
    }
    
    public func downloadURL(for path: String, complition: @escaping (Result<URL, Error>) -> Void){
        let reference = storage.child(path)
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                complition(.failure(StorageErrors.failedToGetDowloadUrl))
                return
            }
            complition(.success(url))
        }
    }
}
