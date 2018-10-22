//
//  VideoGameManager.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/15/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit

class VideoGameManager {
    
    
    
    // This class just handles the static arrays of games.
    static var outGameList = [VideoGame]()
    static var inGameList = [VideoGame]()
    
    static func setUp() {
        let inGameListFilter: [VideoGame] = DataManager.sharedInstance.objectsArray.filter { $0.beenCheckedOut == false }
        inGameList = inGameListFilter
        let outGameListFilter: [VideoGame] = DataManager.sharedInstance.objectsArray.filter { $0.beenCheckedOut == true }
        outGameList = outGameListFilter
    }
    
    
    
    
    static func createGame(name: String, description: String, rating: String, dueDate: String, beenCheckedOut: Bool, image: String, genre: String) {
        let videoGame = VideoGame()
        videoGame.name = name
        videoGame.gameDescription = description
        videoGame.rating = rating
        videoGame.dueDate = dueDate
        videoGame.beenCheckedOut = beenCheckedOut
        videoGame.image = image
        videoGame.genre = genre
        try! DataManager.sharedInstance.realm.write {
            DataManager.sharedInstance.realm.add(videoGame)
        }
    }
    

}

