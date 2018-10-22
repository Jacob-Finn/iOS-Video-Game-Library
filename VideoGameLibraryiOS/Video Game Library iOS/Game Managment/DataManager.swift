//
//  DataManager.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/19/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager {
    // Handles all realm data management.
    
    
    static var sharedInstance = DataManager()
    let realm = try! Realm()
    var objectsArray: Results<VideoGame> {
        get {
            return realm.objects(VideoGame.self)
        }
    }
    
    
    private init () {
    }
}

