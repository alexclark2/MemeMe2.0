//
//  CollectionViewController.swift
//  MemeMe 2.0
//
//  Created by MACBOOK on 12/25/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Foundation
import UIKit


var meme: Meme!

private let reuseIdentifier = "CollectionViewCell"

class MemesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    private var currentIndexPath: NSIndexPath!
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if collectionView != nil {
            collectionView?.reloadData()
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    
    func showEmptyView(_ show: Bool) {
        if show {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView!.frame.width, height: collectionView!.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "No Memes Stored!\nClick '+' to create a new Meme."
            collectionView!.backgroundView = label
        } else {
            collectionView!.backgroundView = nil
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let memeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeMeDetailViewController
        memeDetailViewController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        appDelegate.memes.count == 0 ? showEmptyView(true) : showEmptyView(false)
        return appDelegate.memes.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeMeCollectionViewCell
        let meme: Meme = appDelegate.memes[indexPath.row]
        cell.MemeImg!.image = meme.memedImage
        return cell
    }
    
}
