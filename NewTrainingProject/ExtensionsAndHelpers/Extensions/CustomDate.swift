//
//  CustomDate.swift
//  NewTrainingProject
//
//  Created by Artem Vorobev on 20.12.2022.
//

import UIKit

extension Date {
    static func dateFromCustomString(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from: string) ?? Date()
    }
    
}


class CustomDate {
    static func dateString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func dateFromCustomString(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from: string)!
    }
}

