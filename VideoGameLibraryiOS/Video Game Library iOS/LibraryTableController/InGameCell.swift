//
//  VideoGameCell.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/15/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit

class InGameCell : UITableViewCell {
    
    @IBOutlet weak var staticDueDateLabel: UILabel! // rename
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    
    
    
    
    
    func setup(to game: VideoGame) {
        print("setting up")
        moreInfoButton.isHidden = true
        deleteButton.isHidden = true
        checkoutButton.isHidden = true
        
        descriptionLabel.text = "\(game.description)\nRating: \(game.rating.rawValue)"
        nameLabel.text = game.name
        if game.checkedInDate != "" {
            dateLabel.isHidden = false
            staticDueDateLabel.isHidden = false
            dateLabel.text = game.checkedInDate
        } else {
            dateLabel.isHidden = true
            staticDueDateLabel.isHidden = true
        }
        moreInfoButton.alpha = 0.0
        deleteButton.alpha = 0.0
        checkoutButton.alpha = 0.0
    }
    
    func onSelection() {
        descriptionLabel.isHidden = true
        deleteButton.isHidden = false
        checkoutButton.isHidden = false
        moreInfoButton.isHidden = false
        onSelectionAnimation()
        
    }
    func onUnselection() {
        moreInfoButton.backgroundColor = UIColor.gray
        deleteButton.backgroundColor = UIColor.red
        checkoutButton.backgroundColor = UIColor.green
        descriptionLabel.isHidden = false
        moreInfoButton.isHidden = true
        deleteButton.isHidden = true
        checkoutButton.isHidden = true
        onUnselectionAnimation()
        
    }
    
    
    func onSelectionAnimation() {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)
        animator.addAnimations {
            self.descriptionLabel.alpha = 0.0
            self.checkoutButton.alpha = 1.0
            self.moreInfoButton.alpha = 1.0
            self.deleteButton.alpha = 1.0

        }
        animator.startAnimation()
    }
    
    
    func onUnselectionAnimation() {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)
        animator.addAnimations {
            self.checkoutButton.alpha = 0.0
            self.descriptionLabel.alpha = 1.0
            self.moreInfoButton.alpha = 0.0
            self.deleteButton.alpha = 0.0
        }
        animator.startAnimation()
    }
    
}
