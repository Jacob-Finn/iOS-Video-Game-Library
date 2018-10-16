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
    
}
