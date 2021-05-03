//
//  ProfileViewController.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 13/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var personImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personImageView.roundCornersForAspectFit(
            radius: personImageView.frame.width / 2.0 )
    }
    
}
