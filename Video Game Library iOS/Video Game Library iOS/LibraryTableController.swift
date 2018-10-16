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
    var currentlySelectedGame = VideoGame(name: "", description: "", rating: .E)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let cell = tableView.cellForRow(at: indexPath) as! VideoGameCell
        currentlySelectedGame = VideoGameManager.videoGameList[indexPath.row]
        cell.onSelection()
    }
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! VideoGameCell
        cell.onUnselection()
        return indexPath
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VideoGameManager.videoGameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = VideoGameManager.videoGameList[indexPath.row]
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") as! VideoGameCell
        cell.setup(to: game)
        VideoGameManager.videoGameLocation[indexPath.row] = cell
        cell.deleteButton.tag = indexPath.row
        cell.moreInfoButton.tag = indexPath.row
        cell.checkoutButton.tag = indexPath.row
        cell.checkoutButton.addTarget(self, action: #selector(checkOut(sender:)), for: .touchUpInside)
        cell.moreInfoButton.addTarget(self, action: #selector(showMoreInfo(sender:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func checkOut(sender: UIButton) {
        
    }
    
    @objc func deleteCell(sender: UIButton) {
        let animator = UIViewPropertyAnimator(duration: 2, curve: .easeIn)
        let cell = VideoGameManager.videoGameLocation[sender.tag]
        animator.addAnimations {
            // Fix me later so the cell slides off screen and deletes
        }
        animator.startAnimation()
        VideoGameManager.videoGameList.remove(at: sender.tag)
        tableView.reloadData()
    }
    
    @objc func showMoreInfo(sender: UIButton) {
        performSegue(withIdentifier: "info", sender: self)
        // Show more info over the selected object later!
    }
    
    
    // END OF TABLE VIEW STUFF
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let game1 = VideoGame(name: "I am debug", description: "The return of the debug that will strike back", rating: .M)
        let game2 = VideoGame(name: "Minecraft", description: "Mine diamonds", rating: .E)
        VideoGameManager.videoGameList.append(game1)
        VideoGameManager.videoGameList.append(game2)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is InfoViewController
        {
            guard let infoViewController = segue.destination as? InfoViewController else {
                print("error")
                return
            }
           infoViewController.setupGame = currentlySelectedGame
        }
    }
    
}
