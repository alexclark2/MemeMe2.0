//
//  TableViewController.swift
//  MemeMe 2.0
//
//  Created by MACBOOK on 12/25/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Foundation
import UIKit

class MemeMeTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes

        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appDelegate.memes.count == 0 ? showEmptyView(true) : showEmptyView(false)
        return appDelegate.memes.count
    }
    
    func showEmptyView(_ show: Bool) {
        if show {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "No Memes Stored!\nClick '+' to create a new Meme."
            tableView.separatorStyle = .none
            tableView.backgroundView = label
            navigationItem.leftBarButtonItem = nil
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            navigationItem.leftBarButtonItem = editButtonItem
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! MemeMeTableViewCell
        let meme: Meme = appDelegate.memes[indexPath.row]
        cell.cellImageView.image = meme.memedImage
        cell.cellTextLabel.text = meme.topTextField
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeMeDetailViewController
        memeDetailViewController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
    
}
