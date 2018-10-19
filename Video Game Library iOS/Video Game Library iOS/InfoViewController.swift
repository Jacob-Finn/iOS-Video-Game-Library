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
    
    
    
    var setupGame = VideoGame(name: "", description: "", rating: .E)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.layer.cornerRadius = 6.0
        editButton.layer.borderWidth = 2.0
        gameImageView.image = setupGame.image
        titleLabel.text = setupGame.name
        ratingLabel.text = setupGame.rating.rawValue
        descriptionLabel.text = setupGame.description
        
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
}
