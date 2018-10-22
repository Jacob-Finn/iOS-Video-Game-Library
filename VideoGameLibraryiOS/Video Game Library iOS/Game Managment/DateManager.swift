//
//  DateManager.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/18/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import Foundation

class DateManager { // This class is only used to determine if a cell should become red or not.
    
    static func isLate(game: VideoGame) -> Bool {
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let gameDate = dateFormatter.date(from: game.dueDate) else {
            return false
        }
        if gameDate < todayDate {
            return true
        } else {
            return false
        }
        
        
    }
    
}
