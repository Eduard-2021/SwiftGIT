//
//  AllGroupsTableController.swift
//  VK_PlusHW3
//
//  Created by Eduard on 07.04.2021.
//

import UIKit

class AllGroupsTableController: UITableViewController, UISearchBarDelegate {
    let loadAllGroupsWithAdapter = LoadAllGroupsWithAdapter.shared

    var allGroupsForAdapter = [AllGroupsForAdapter]()
    
    @IBOutlet weak var searchTextForAllGroups: UISearchBar!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroupsForAdapter.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendAndGroupCell", for: indexPath) as! FriendAndGroupCell
        cell.configure(imageURL: allGroupsForAdapter[indexPath.row].imageGroupURL, name: allGroupsForAdapter[indexPath.row].nameGroup)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        HeightOfSell.middle.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FriendAndGroupCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendAndGroupCell")
        loadAllGroupsWithAdapter.loadAllGroups(textForSearchInAllGroups: textForSearch, vc: self) { [weak self] (allGroups) in
            guard let self = self else {return}
            let allGroupsForAdapter = allGroups
            self.allGroupsForAdapter = allGroupsForAdapter
            self.tableView.reloadData()
        }
        searchTextForAllGroups.delegate = self
        searchTextForAllGroups.text = textForSearch
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadAllGroupsWithAdapter.loadAllGroupsAfterSearch(textForSearchInAllGroups: searchText)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addGroupWithSegue", sender: nil)
    }
}

extension AllGroupsTableController: ReloadAllGroupsController{
    func reloadController() {
        tableView.reloadData()
    }
}
