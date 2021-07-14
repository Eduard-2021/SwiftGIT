//
//  AllGroupsTableController.swift
//  VK_PlusHW3
//
//  Created by Eduard on 07.04.2021.
//

import UIKit
import RealmSwift

class AllGroupsTableController: UITableViewController, UISearchBarDelegate {

    private let networkService = MainNetworkService()
    var allGroupsInRealm = try? RealmService.load(typeOf: RealmAllGroups.self, sortedKey: "idGroup")
    var token: NotificationToken?
    
    @IBOutlet weak var searchTextForAllGroups: UISearchBar!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroupsInRealm?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendAndGroupCell", for: indexPath) as! FriendAndGroupCell
        cell.configure(imageURL: allGroupsInRealm![indexPath.row].imageGroupURL, name: allGroupsInRealm![indexPath.row].nameGroup)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        HeightOfSell.middle.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FriendAndGroupCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendAndGroupCell")
        loadAndSaveAllGroupsInRealm(textForSearchInAllGroups: textForSearch)
        updateTableViewFromRealm()
        searchTextForAllGroups.delegate = self
        searchTextForAllGroups.text = textForSearch

    }
    
    private func updateTableViewFromRealm() {
        guard let allGroupsInRealm = self.allGroupsInRealm else {return}
        
        self.token = allGroupsInRealm.observe { [self]  (changes: RealmCollectionChange) in
                    switch changes {
                    case .initial:
                                    self.tableView.reloadData()
                    case .update(_, let deletions, let insertions, let modifications):
                       
                                    self.tableView.reloadData()
                    case .error(let error):
                        print(error)
                    }
                }

    }
    
    private func loadAndSaveAllGroupsInRealm(textForSearchInAllGroups : String){
        networkService.groupsSearch(textForSearch: textForSearchInAllGroups, numberGroups: 10, completion: { allSearchedGroups in
            guard
                let allSearchGroupsVK = allSearchedGroups
            else {return}
            guard let groupsForDelete = self.allGroupsInRealm else {return}
            try? RealmService.delete(object: groupsForDelete)
            try? RealmService.save(items: allSearchGroupsVK)
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
        textForSearch = searchText
            loadAndSaveAllGroupsInRealm(textForSearchInAllGroups: textForSearch)}
        else {
            guard let groupsForDelete = self.allGroupsInRealm else {return}
            try? RealmService.delete(object: groupsForDelete)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addGroupWithSegue", sender: nil)
    }
}


