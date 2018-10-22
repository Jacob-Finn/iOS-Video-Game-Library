//
//  VideoGameManager.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/15/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit

class VideoGameManager {
    
    
    
    // This class handles anything relating to the creation and deletion of VideoGames and their containing arrays
    
    static var outGameList = [VideoGame]()
    static var inGameList = [VideoGame]()
    
    // The setup function reassigns the InGameList and OutGameList based on the currently avaible realm data
    static func setUp() {
        let inGameListFilter: [VideoGame] = DataManager.sharedInstance.objectsArray.filter { $0.beenCheckedOut == false }
        inGameList = inGameListFilter
        let outGameListFilter: [VideoGame] = DataManager.sharedInstance.objectsArray.filter { $0.beenCheckedOut == true }
        outGameList = outGameListFilter
    }
    
    static func delete(game: VideoGame) {
        try! DataManager.sharedInstance.realm.write {
            DataManager.sharedInstance.realm.delete(game)
        }
        setUp()
    }
    
    
    
    
    
    // The new init for the video game function that also adds the game into the realm data base at the end.
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

