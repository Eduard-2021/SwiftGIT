//
//  AllGroupsTableController.swift
//  VK_PlusHW3
//
//  Created by Eduard on 07.04.2021.
//

import UIKit
import RealmSwift

class AllGroupsTableController: UITableViewController {

    private let networkService = MainNetworkService()
    var allGroupsInRealm = try? RealmService.load(typeOf: RealmAllGroups.self, sortedKey: "idGroup")
    var token: NotificationToken?
    
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
        loadAndSaveAllGroupsInRealm()

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
    
    private func loadAndSaveAllGroupsInRealm(){
        networkService.groupsSearch(textForSearch: "Music", numberGroups: 10, completion: { allSearchedGroups in
            guard
                let allSearchGroupsVK = allSearchedGroups
            else {return}
            try? RealmService.save(items: allSearchGroupsVK)
            self.tableView.reloadData()
            self.updateTableViewFromRealm()
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addGroupWithSegue", sender: nil)
    }
}


