//
//  MemeMeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by MACBOOK on 12/30/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class MemeMeDetailViewController: UIViewController {
    

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var meme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        imageView!.image = meme?.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    

}
