//
//  LibraryTableController.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/15/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit

class LibraryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentlySelectedGame = VideoGame(name: "", description: "", rating: .E, genre: "")
    var currentlySelectedIndex = IndexPath.init()
    
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
    
    @objc func checkOut(sender: UIButton) {
        let cell = tableView.cellForRow(at: currentlySelectedIndex) as? InGameCell
        cell?.onUnselection()
        VideoGameManager.inGameList[sender.tag].checkOut()
        VideoGameManager.outGameList.append(VideoGameManager.inGameList[sender.tag])
        VideoGameManager.inGameList.remove(at: sender.tag)
        tableView.reloadData()
    }
    
    @objc func deleteCell(sender: UIButton) {
        let animator = UIViewPropertyAnimator(duration: 2, curve: .easeIn)
        animator.addAnimations {
            // Fix me later so the cell slides off screen and deletes
        }
        animator.startAnimation()
        VideoGameManager.inGameList.remove(at: sender.tag)
        tableView.reloadData()
    }
    
    @objc func showMoreInfo(sender: UIButton) {
        performSegue(withIdentifier: "info", sender: self)
        // Show more info over the selected object later!
    }
    
    
    // END OF TABLE VIEW STUFF
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if VideoGameManager.setup == false {
            let game1 = VideoGame(name: "I am debug", description: "The return of the debug that will strike back", rating: .M, genre: "Debug")
            let game2 = VideoGame(name: "Minecraft", description: "Mine diamonds", rating: .E, genre: "Sandbox")
            VideoGameManager.inGameList.append(game1)
            VideoGameManager.inGameList.append(game2)
            game1.loadImage()
            VideoGameManager.setup = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if currentlySelectedIndex != [] { // Basically if it is nil
            let cell = tableView.cellForRow(at: currentlySelectedIndex) as? InGameCell
            cell?.onUnselection()
        } else {
            return
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View disappearing.")
        tableView.reloadData()
    }
    
    
    
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
