//
//  MyProfileViewController.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 22/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var quotesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyProfile.synchronize()
        setupGreetingLabel()
        setupPhotoProfile()
        lastNameLabel.text = MyProfile.lastName
        nameLabel.text = "\(MyProfile.firstName) \(MyProfile.lastName)"
        nationalityLabel.text = MyProfile.nationality
        quotesLabel.text = gameQuotes[Int.random(in: 0..<gameQuotes.count)]
    }
    
    @IBAction func editProfile(_ sender: UIBarButtonItem) {
        guard let createVC = storyboard?.instantiateViewController(identifier: "CreateScene")
            as? EditProfileViewController
            else { return }
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    func setupGreetingLabel() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12 : greetingLabel.text = "Good Morning"
        case 12..<17 : greetingLabel.text = "Good Afternoon"
        case 17..<22 : greetingLabel.text = "Good Evening"
        default: greetingLabel.text = "Good Night"
        }
    }
    
    func setupPhotoProfile() {
        photoView.image = UIImage(data: MyProfile.photo)
        photoView.layer.cornerRadius = self.photoView.frame.height / 2
        photoView.clipsToBounds = true
    }

}

private let gameQuotes = ["""
"We all make choices in life, but in the end our choices make us." Andrew Ryan, Bioshock
""",
                          """
"The right man in the wrong place can make all the difference in the world." G-Man, Half-Life 2
""",
                          """
"Wanting something does not give you the right to have it." Ezio Auditore, Assassin’s Creed 2
""",
                          """
"Don't wish it were easier, wish you were better." Chief, Animal Crossing
""",
                          """
"No matter how dark the night, morning always comes, and our journey begins anew." Lulu, Final Fantasy X
""",
                          """
"Hard to see big picture behind pile of corpses." Mordin Solus, Mass Effect 3
""",
                          """
"What is better? To be born good or to overcome your evil nature through great effort?" Paarthurnax, Elder Scrolls V: Skyrim
"""
]
