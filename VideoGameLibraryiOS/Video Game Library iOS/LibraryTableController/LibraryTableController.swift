//
//  LibraryTableController.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/15/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit

class LibraryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // The main view controller. It handles the games that are inside the library. Works very closly to the
    // CheckedOutViewController.
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentlySelectedGame = VideoGame()
    var currentlySelectedIndex = IndexPath.init() // Used to manage the currently selected cell/game
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let cell = tableView.cellForRow(at: indexPath) as! InGameCell
        currentlySelectedGame = VideoGameManager.inGameList[indexPath.row]
        currentlySelectedIndex = indexPath
        cell.onSelection()
    }
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! InGameCell
        cell.onUnselection()
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VideoGameManager.inGameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = VideoGameManager.inGameList[indexPath.row]
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") as! InGameCell
        cell.setup(to: game)
        cell.deleteButton.tag = indexPath.row
        cell.moreInfoButton.tag = indexPath.row
        cell.checkoutButton.tag = indexPath.row
        cell.checkoutButton.addTarget(self, action: #selector(checkOut(sender:)), for: .touchUpInside)
        cell.moreInfoButton.addTarget(self, action: #selector(showMoreInfo(sender:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
        return cell
    }
    
    // Whenever the checkout button is pressed, we'll call this function which will tell the game it should
    // check out, and then that it should reload the row with the animation sliding to the right, and when it
    // slides to the right, it is deleted.
    @objc func checkOut(sender: UIButton) {
        let cell = tableView.cellForRow(at: currentlySelectedIndex) as? InGameCell
        cell?.onUnselection()
        try! DataManager.sharedInstance.realm.write {
            VideoGameManager.inGameList[sender.tag].checkOut()
        }
        tableView.reloadRows(at: [currentlySelectedIndex], with: UITableView.RowAnimation.right)
        VideoGameManager.setUp() // We call setup here to reassign and setup the game lists.
        tableView.reloadData()
    }
    
    // deletes the selected cell completely.
    @objc func deleteCell(sender: UIButton) {
        tableView.reloadRows(at: [currentlySelectedIndex], with: UITableView.RowAnimation.left)
        VideoGameManager.inGameList.remove(at: sender.tag)
        try! DataManager.sharedInstance.realm.write {
            DataManager.sharedInstance.realm.delete(VideoGameManager.inGameList[sender.tag])
        }
        VideoGameManager.setUp() // We call setup here to reassign and setup the game lists.
        tableView.reloadData()
    }
    
    @objc func showMoreInfo(sender: UIButton) {
        performSegue(withIdentifier: "info", sender: self)
        // Show more info over the selected object later!
    }
    
    
    // END OF TABLE VIEW STUFF
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DataManager.sharedInstance.objectsArray.count == 0 {
            VideoGameManager.createGame(name: "Tester", description: "debug", rating: "Teen", dueDate: "", beenCheckedOut: false, image: "missingImage", genre: "Debugging")
            VideoGameManager.createGame(name: "Testertwo", description: "debug", rating: "Teen", dueDate: "", beenCheckedOut: false, image: "missingImage", genre: "Debugging")
        }
        VideoGameManager.setUp()
    }
    // Whenever we are moving away from the screen, if we have a cell selected we need to make sure to call its
    // onUnselection, or else we'll have a cell that has buttons still on display when we return to the screen.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if currentlySelectedIndex != [] { // Basically if it is nil
            let cell = tableView.cellForRow(at: currentlySelectedIndex) as? InGameCell
            cell?.onUnselection()
        } else {
            return
        }
    }
    
    
    // Whenever we are going to show the view, to be safe we'll go ahead and reload the tablecell.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // Whenever the add button is tapped, we instantiate the Creator view controller with the dataPassage of
    // .create, this tells the Creator class how it needs to create the VideoGame, like if you're suppose to
    // editing and replacing a video game in the out list, in list, or if nothing needs to be replaced and it
    // is a brand new game, thus, we have the .create.
    @IBAction func addTapped(_ sender: Any) {
        let creatorView: UIStoryboard = UIStoryboard(name: "Creator", bundle: nil)
        let creatorVC = creatorView.instantiateViewController(withIdentifier: "create") as! CreatorViewController
        creatorVC.dataPassage = .create
        self.present(creatorVC, animated: false, completion: nil)
    }
    
    
    // If we're going to go to the InfoViewController from the more info button, we'll pass in some essential
    // information for it to load the game and display it.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is InfoViewController
        {
            guard let infoViewController = segue.destination as? InfoViewController else {
                print("error")
                return
            }
            infoViewController.dataPassage = .inGameList
            infoViewController.setupGameLocation = currentlySelectedIndex.row
        }
    }
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) { }
    
}
