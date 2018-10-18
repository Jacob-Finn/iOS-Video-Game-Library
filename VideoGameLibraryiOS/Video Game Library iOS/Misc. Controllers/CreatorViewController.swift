//
//  CreatorViewController.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/17/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit

class CreatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    

    
    @IBOutlet weak var finishButton: UIButton!
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
    var setDueDate = ""
    var dataPassage: DataPassage = .inGameList
    var button = DropDownButton()
    let imagePicker = UIImagePickerController()
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        button.dismissDropDown()
    }
    
    
    @IBAction func dateEditingChanged(_ sender: Any) {
        var savedText: String // Allows for easy modification of text
        if dueDateEditor.text?.count == 2 {
            savedText = dueDateEditor.text!
            savedText.append("/")
            dueDateEditor.text = savedText
        }
        if dueDateEditor.text?.count == 5 {
            savedText = dueDateEditor.text!
            savedText.append("/")
            dueDateEditor.text = savedText
        }
        if dueDateEditor.text?.count == 10 {
            savedText = dueDateEditor.text!
            savedText.removeLast()
        }
    }
    
    @IBAction func dateEditingBegan(_ sender: Any) {
       dueDateEditor.text = ""
    }
    
    @IBAction func dateEditorFinished(_ sender: UITextField) {
        if dueDateEditor.text == "" {
            dueDateEditor.text = setDueDate
            return
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            if let dueDate = dateFormatter.date(from: dueDateEditor.text!) {
                print("valid date")
                setDueDate = dateFormatter.string(from: dueDate)
                print("/n/n/n/n/m \(setDueDate)/n/n")
            } else { //Invalid date
                dueDateEditor.text = "Invalid date!"
                print("invalid date")
            }
        }
    }
    
    
    @IBAction func loadImageTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        if currentlySelectedIndex != -1 {
            if dataPassage == .inGameList {
                currentlySelectedGame = VideoGameManager.inGameList[currentlySelectedIndex]
                
            } else {
                currentlySelectedGame = VideoGameManager.outGameList[currentlySelectedIndex]
            }
        }
        setDueDate = currentlySelectedGame.dueDate
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
        
        
        imageView.image = currentlySelectedGame.image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    }
    
    
    @IBAction func finishTapped(_ sender: Any) {
        
        
        
        switch dataPassage {
        case .create:
            let newGame = VideoGame(name: titleEditor.text!, description: descriptionEditor.text, dueDate: setDueDate, checkedInDate: currentlySelectedGame.checkedInDate, rating: Rating(rawValue: (button.titleLabel?.text)!)!, genre: genreEditor.text!, beenCheckedOut: currentlySelectedGame.beenCheckedOut, image: imageView.image!)
            VideoGameManager.inGameList.append(newGame)
            self.performSegue(withIdentifier: "unwindToMain", sender: self)
            
            
        case .inGameList:
            print("adding things to ingame")
            let newGame = VideoGame(name: titleEditor.text!, description: descriptionEditor.text, dueDate: setDueDate, checkedInDate: currentlySelectedGame.checkedInDate, rating: Rating(rawValue: (button.titleLabel?.text)!)!, genre: genreEditor.text!, beenCheckedOut: currentlySelectedGame.beenCheckedOut, image: imageView.image!)
            VideoGameManager.inGameList.remove(at: currentlySelectedIndex)
            VideoGameManager.inGameList.insert(newGame, at: currentlySelectedIndex)
            self.performSegue(withIdentifier: "unwindToMain", sender: self)
            
        case .outGameList:
            print("addings things to outgame")
            let newGame = VideoGame(name: titleEditor.text!, description: descriptionEditor.text, dueDate: setDueDate, checkedInDate: currentlySelectedGame.checkedInDate, rating: Rating(rawValue: (button.titleLabel?.text)!)!, genre: genreEditor.text!, beenCheckedOut: currentlySelectedGame.beenCheckedOut, image: imageView.image!)
            VideoGameManager.outGameList.remove(at: currentlySelectedIndex)
            VideoGameManager.outGameList.insert(newGame, at: currentlySelectedIndex)
            self.performSegue(withIdentifier: "unwindToOut", sender: self)
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
