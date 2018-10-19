//
//  VideoGame.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/15/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit

enum Rating: String {
    case E = "Everyone"
    case T = "Teen"
    case M = "Mature"
}


class VideoGame {
    var name: String
    var description: String
    var dueDate: String
    var beenCheckedOut: Bool
    var checkedInDate: String
    var image: UIImage?
    
    var rating: Rating
    
    init (name: String, description: String, rating: Rating) {
        self.name = name
        self.description = description
        self.dueDate = ""
        self.beenCheckedOut = false
        self.rating = rating
        self.checkedInDate = ""
        self.image = setupImage()
    }
    
    
    func setupImage() -> UIImage {
        guard let image = UIImage(named: self.name) else {
            let errorImage = UIImage(named: "missingImage")
            return errorImage!
        }
        return image
    }
    
    func checkOut() {
        let calander = Calendar.init(identifier: .gregorian)
        let today = Date()
        let dateFormatter = DateFormatter()
        let calculatedDate = calander.date(byAdding: .day, value: 14, to: today)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.dueDate = dateFormatter.string(from: calculatedDate!)
    }
    func checkIn() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.dueDate = ""
        self.checkedInDate = dateFormatter.string(from: today)
    }
    
    func loadImage(filename: String) -> UIImage? {
        let fileManager = FileManager()
        let home = fileManager.currentDirectoryPath
        let imagePath = ("/\(filename).png")
        let filepath = ("\(home)\(imagePath)")
        print(filepath)
        
        return nil
        
    }
}

