//
//  PlatformListViewController.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 22/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

class PlatformListViewController: UIViewController, UITableViewDataSource {
    
    var names = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "platform", for: indexPath) as? PlatformNameTableViewCell {
            let name = names[indexPath.row]
            cell.nameLabel.text = name
            return cell
        } else { return UITableViewCell() }
    }
    

    @IBOutlet weak var nameTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTableView.dataSource = self
    }

}
