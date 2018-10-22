//
//  VideoGame.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/15/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift




class VideoGame: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var gameDescription: String = ""
    @objc dynamic var dueDate: String = ""
    @objc dynamic var beenCheckedOut: Bool = false
    @objc dynamic var checkedInDate: String = ""
    @objc dynamic var image: String = "missingImage"
    @objc dynamic var genre: String = ""
    @objc dynamic var rating: String = ""
    @objc dynamic var positionInArray: Int = 0
    
    
    
// not functional with realm.
    func loadImage() -> UIImage {
        guard let image = UIImage(named: self.image) else {
            let errorImage = UIImage(named: "missingImage")
            return errorImage!
        }
        return image
        // If the image doesn't exist, we just set up a default missingImage picture, the users can always change
        // this later.
    }
    
    
    func checkOut() {
        let calander = Calendar.init(identifier: .gregorian)
        let today = Date()
        let dateFormatter = DateFormatter()
        let calculatedDate = calander.date(byAdding: .day, value: 14, to: today)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.beenCheckedOut = true
        self.dueDate = dateFormatter.string(from: calculatedDate!)
    }
    func checkIn() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.dueDate = ""
        self.beenCheckedOut = false
        self.checkedInDate = dateFormatter.string(from: today)
    }
    

}

