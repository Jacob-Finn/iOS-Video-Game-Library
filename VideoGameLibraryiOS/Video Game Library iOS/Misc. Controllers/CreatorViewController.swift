//
//  CreatorViewController.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/17/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit

class CreatorViewController: UIViewController {
    
    // DUE DATE EDITOR NEEDS TO CHECK FOR PROPER FORMATTING MM/DD/YYYY
    // WHEN WE CREATE THE EDITED VIDEO GAME WE NEED TO GRAB THE DATE AND MAKE SURE IT CONVERTS BEFORE ASSIGNING IT!
    // MAKE THE EDITOR UNWIND TO THE CORRECT PLACE DEPENDING ON WHICH LIST YOU EDITED FROM TO BEGIN WITH
    // CONSTRAINTS AND GENERAL APPERANCE
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dueDateEditor: UITextField!
    @IBOutlet weak var descriptionEditor: UITextView!
    @IBOutlet weak var genreEditor: UITextField!
    @IBOutlet weak var titleEditor: UITextField!
    var currentlySelectedIndex = -1
    var currentlySelectedGame = VideoGame(name: "", description: "", rating: .E, genre: "")
    enum DataPassage {
        case inGameList
        case outGameList
        case create
    }
    var dataPassage: DataPassage = .inGameList
    var button = DropDownButton()
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        button.dismissDropDown()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentlySelectedIndex != -1 {
            if dataPassage == .inGameList {
                currentlySelectedGame = VideoGameManager.inGameList[currentlySelectedIndex]
            } else {
                currentlySelectedGame = VideoGameManager.outGameList[currentlySelectedIndex]
            }
        }
        titleEditor.text = currentlySelectedGame.name
        genreEditor.text = currentlySelectedGame.genre
        descriptionEditor.text = currentlySelectedGame.description
        if currentlySelectedGame.beenCheckedOut {
            dueDateEditor.isHidden = false
            dueDateLabel.isHidden = false
            dateLabel.isHidden = false
            dueDateEditor.text = currentlySelectedGame.dueDate
        } else {
            dueDateEditor.isHidden = true
            dateLabel.isHidden = true
            dueDateLabel.isHidden = true
        }
        descriptionEditor.layer.borderWidth = 2
        
        button = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.setTitle("\(currentlySelectedGame.rating.rawValue)", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        //button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor).isActive = true
        //button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
        //button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.widthAnchor.constraint(equalToConstant: ratingView.frame.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: ratingView.frame.height).isActive = true
        button.setupDropView()
        button.dropView.dropDownOptions = ["Everyone", "Teen", "Mature"]
        imageView.image = currentlySelectedGame.image
    }
    
    
    
    @IBAction func finishTapped(_ sender: Any) {
        

        
        switch dataPassage {
        case .create:
            let newGame = VideoGame(name: titleEditor.text!, description: descriptionEditor.text, dueDate: dueDateEditor.text!, checkedInDate: currentlySelectedGame.checkedInDate, rating: Rating(rawValue: (button.titleLabel?.text)!)!, genre: genreEditor.text!, beenCheckedOut: currentlySelectedGame.beenCheckedOut)
            VideoGameManager.inGameList.append(newGame)
        case .inGameList:
            print("adding things to ingame")
            let newGame = VideoGame(name: titleEditor.text!, description: descriptionEditor.text, dueDate: dueDateEditor.text!, checkedInDate: currentlySelectedGame.checkedInDate, rating: Rating(rawValue: (button.titleLabel?.text)!)!, genre: genreEditor.text!, beenCheckedOut: currentlySelectedGame.beenCheckedOut)
            VideoGameManager.inGameList.remove(at: currentlySelectedIndex)
            VideoGameManager.inGameList.insert(newGame, at: currentlySelectedIndex)
        case .outGameList:
            print("addings things to outgame")
            let newGame = VideoGame(name: titleEditor.text!, description: descriptionEditor.text, dueDate: dueDateEditor.text!, checkedInDate: currentlySelectedGame.checkedInDate, rating: Rating(rawValue: (button.titleLabel?.text)!)!, genre: genreEditor.text!, beenCheckedOut: currentlySelectedGame.beenCheckedOut)
            VideoGameManager.outGameList.remove(at: currentlySelectedIndex)
            VideoGameManager.outGameList.insert(newGame, at: currentlySelectedIndex)
            print("no")
        }
    }
}














// THIS IS STUFF FOR THE DROP DOWN BUTTON PAST THIS POINT.

protocol dropDownProtocol {
    func dropDownPressed(string: String)
}

class DropDownButton: UIButton, dropDownProtocol {
    
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
        self.dismissDropDown()
    }
    
    
    var dropView = DropDownView()
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        dropView = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    func setupDropView() {
        self.superview?.addSubview(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            self.height.constant = 150
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
                
            }, completion: nil)
            
        } else {
            isOpen = false
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
}


class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    var delegate: dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.darkGray
        self.backgroundColor = UIColor.darkGray
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
