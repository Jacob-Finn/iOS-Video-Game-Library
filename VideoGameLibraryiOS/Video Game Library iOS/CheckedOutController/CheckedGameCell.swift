//
//  CheckedGameCell.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/16/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit

class CheckedGameCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    
    
    func setup(to game: VideoGame) {
        titleLabel.text = game.name
        descriptionLabel.text = "\(game.description)\nRating: \(game.rating.rawValue)"
        dueDateLabel.text = game.dueDate
        
        moreInfoButton.isHidden = true
        deleteButton.isHidden = true
        checkInButton.isHidden = true
        moreInfoButton.alpha = 0.0
        deleteButton.alpha = 0.0
        checkInButton.alpha = 0.0
    }
    
    
    func onSelection() {
        descriptionLabel.isHidden = true
        deleteButton.isHidden = false
        checkInButton.isHidden = false
        moreInfoButton.isHidden = false
        onSelectionAnimation()
    }
    
    func onUnselection() {
        descriptionLabel.isHidden = false
        moreInfoButton.isHidden = true
        deleteButton.isHidden = true
        checkInButton.isHidden = true
        onUnselectionAnimation()
        
    }
    
    func onSelectionAnimation() {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)
        animator.addAnimations {
            self.descriptionLabel.alpha = 0.0
            self.checkInButton.alpha = 1.0
            self.moreInfoButton.alpha = 1.0
            self.deleteButton.alpha = 1.0
        }
        animator.startAnimation()
    }
    
    func onUnselectionAnimation() {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)
        animator.addAnimations {
            self.checkInButton.alpha = 0.0
            self.descriptionLabel.alpha = 1.0
            self.moreInfoButton.alpha = 0.0
            self.deleteButton.alpha = 0.0
        }
        animator.startAnimation()
    }
    
    
}
