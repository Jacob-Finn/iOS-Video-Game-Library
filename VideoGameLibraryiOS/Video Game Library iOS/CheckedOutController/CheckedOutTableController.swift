//
//  CheckedOutTableController.swift
//  Video Game Library iOS
//
//  Created by Jacob Finn on 10/16/18.
//  Copyright © 2018 Jacob Finn. All rights reserved.
//

import UIKit

class CheckedOutTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var currentlySelectedGame = VideoGame(name: "", description: "", rating: .E, genre: "")
    var currentlySelectedIndex = IndexPath.init()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VideoGameManager.outGameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = VideoGameManager.outGameList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CheckedGameCell
        cell.setup(to: game)
        if DateManager.isLate(game: game) {
            cell.backgroundColor = UIColor.red
        } else {
            cell.backgroundColor = UIColor.white
        }
        cell.deleteButton.tag = indexPath.row
        cell.moreInfoButton.tag = indexPath.row
        cell.checkInButton.tag = indexPath.row
        cell.checkInButton.addTarget(self, action: #selector(checkIn(sender:)), for: .touchUpInside)
        cell.moreInfoButton.addTarget(self, action: #selector(showMoreInfo(sender:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let cell = tableView.cellForRow(at: indexPath) as! CheckedGameCell
        currentlySelectedGame = VideoGameManager.outGameList[indexPath.row]
        currentlySelectedIndex = indexPath
        cell.onSelection()
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! CheckedGameCell
        cell.onUnselection()
        return indexPath
    }
    
    @objc func checkIn(sender: UIButton) {
        VideoGameManager.outGameList[sender.tag].checkIn()
        VideoGameManager.inGameList.append(VideoGameManager.outGameList[sender.tag])
        VideoGameManager.outGameList.remove(at: sender.tag)
        tableView.reloadData()
    }
    
    @objc func deleteCell(sender: UIButton) {
        VideoGameManager.outGameList.remove(at: sender.tag)
        tableView.reloadData()
    }
    
    @objc func showMoreInfo(sender: UIButton) {
        performSegue(withIdentifier: "info", sender: self)
        // Show more info over the selected object later!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        print("View will appear.")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if currentlySelectedIndex != [] { // Basically if it is nil
            let cell = tableView.cellForRow(at: currentlySelectedIndex) as? CheckedGameCell
            cell?.onUnselection()
        } else {
            return
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is InfoViewController
        {
            guard let infoViewController = segue.destination as? InfoViewController else {
                print("error")
                return
            }
            infoViewController.dataPassage = .outGameList
            infoViewController.setupGameLocation = currentlySelectedIndex.row
        }
    }
    
    
    @IBAction func unwindToOut(segue:UIStoryboardSegue) { }
    
}
    

