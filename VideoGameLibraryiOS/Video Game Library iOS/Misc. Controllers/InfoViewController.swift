//
//  InfoViewController.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/15/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit
class InfoViewController: UIViewController {
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var checkedInLabel: UILabel!
    @IBOutlet weak var turnInByLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var staticTurnInLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    enum DataPassage {
        case inGameList
        case outGameList
    }
    
    var dataPassage: DataPassage = .inGameList
    var setupGameLocation = 0 // then we'll grab the specific number and then set up the setupGame variable.
    var setupGame = VideoGame() // ***********CHANGE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataPassage == .inGameList {
            setupGame = VideoGameManager.inGameList[setupGameLocation]
        } else {
            setupGame = VideoGameManager.outGameList[setupGameLocation]
        }
        genreLabel.text = setupGame.genre
        editButton.layer.cornerRadius = 6.0
        editButton.layer.borderWidth = 2.0
        gameImageView.image = setupGame.loadImage()
        titleLabel.text = setupGame.name
        ratingLabel.text = setupGame.rating
        descriptionLabel.text = setupGame.gameDescription
        
        if setupGame.dueDate != "" {
            staticTurnInLabel.isHidden = false
            turnInByLabel.isHidden = false
            turnInByLabel.text = setupGame.dueDate
        }
        if setupGame.checkedInDate != "" {
            checkedInLabel.text = setupGame.checkedInDate
        } else {
            checkedInLabel.text = "Hasn't been returned"
        }
    }
    
    
    @IBAction func editTapped(_ sender: Any) {
        let creatorView: UIStoryboard = UIStoryboard(name: "Creator", bundle: nil)
        let creatorVC = creatorView.instantiateViewController(withIdentifier: "create") as! CreatorViewController
        creatorVC.currentlySelectedIndex = setupGameLocation
        if dataPassage == .inGameList {
            creatorVC.dataPassage = .inGameList
        } else {
            creatorVC.dataPassage = .outGameList
        }
        self.present(creatorVC, animated: false, completion: nil)
    }
    
    
    
    
    
    
    
}
