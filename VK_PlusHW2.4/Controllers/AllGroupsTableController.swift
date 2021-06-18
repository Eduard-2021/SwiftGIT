//
//  AllGroupsTableController.swift
//  VK_PlusHW3
//
//  Created by Eduard on 07.04.2021.
//

import UIKit

class AllGroupsTableController: UITableViewController {

//    var allGroups = [
//    Group(imageGroup: UIImage(named: "Audi")!, nameGroup: "Группа любителей ауди"),
//    Group(imageGroup: UIImage(named: "Mercedes")!, nameGroup: "Группа любителей мерседесов"),
//    Group(imageGroup: UIImage(named: "Jaguar")!, nameGroup: "Группа любителей ягуаров"),
//    Group(imageGroup: UIImage(named: "Mini")!, nameGroup: "Группа любителей мини"),
//    Group(imageGroup: UIImage(named: "Mustang")!, nameGroup: "Группа любителей мустангов"),
//    ]

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendAndGroupCell", for: indexPath) as! FriendAndGroupCell
        cell.imageOfFriendOrGroup.image = allGroups[indexPath.row].imageGroup
        cell.nameOfFriendOrGroup.text = allGroups[indexPath.row].nameGroup
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        HeightOfSell.middle.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FriendAndGroupCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendAndGroupCell")

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addGroupWithSegue", sender: nil)
    }
}


