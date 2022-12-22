//
//  DataBaseManager.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 22.12.2022.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

final class DataBaseManager {
    static let shared = DataBaseManager()
    
    private let dataBase = Firestore.firestore()
    
    public func getUserName(user: User, label: DefaultUILabel, completion: @escaping (Result<String, Error>) -> Void){
        dataBase.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(error))
            } else {
                for document in snapshot!.documents {
                    if document.data().contains(where: { (key: String, value: Any) in
                        if key == "uid" && value as! String == user.uid {
                            return true
                        }
                        return false
                    }){
                        var name = ""
                        var lastName = ""
                      document.data().map {(key: String, value: Any) in
                            if key == "name"{
                                name = value as! String
                                //label.text = "\(value)"
                            }
                            if key == "lastName"{
                                lastName = value as! String
                                //label.text! += " " + "\(value)"
                            }
                        }
                        completion(.success("\(name) \(lastName)"))
                    }
                }
            }
        }
    }
}
