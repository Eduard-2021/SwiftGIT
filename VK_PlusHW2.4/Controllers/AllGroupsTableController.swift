//
//  AllGroupsTableController.swift
//  VK_PlusHW3
//
//  Created by Eduard on 07.04.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase
import FirebaseAuth

class AllGroupsTableController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    private let networkService = MainNetworkService()
    var allGroupsInRealm = try? RealmService.load(typeOf: RealmAllGroups.self, sortedKey: "idGroup")
    var token: NotificationToken?
    var realmNotificationActive = false
    
    
    private let ref = Database.database().reference(withPath: "SearchFraze")


    
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
        loadAndSaveGroupsInRealm(textForSearch: searchFraze)
        searchBar.delegate = self
        searchBar.text = searchFraze
        if !self.realmNotificationActive {
            self.updateTableViewFromRealm()
            self.realmNotificationActive = true
        }
        ref.removeValue()
        observeFirebase()
    }
    
    private func observeFirebase() {
            ref.observe(.value, with: {snapshot in
            var currentSearchText: String!
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let searchTextFromFirebase = value["searchText"] as? String,
                   let currentSearchNumber = value["searchNumber"] as? Int,
                   let idUser = value["idUser"] as? Int {
                    if idUser == DataAboutSession.data.userID,  currentSearchNumber == searchNumber - 1 {
                        currentSearchText = searchTextFromFirebase
                    }
                }
            }
                if let currentSearchTextNotWrap = currentSearchText {
                    self.loadAndSaveGroupsInRealm(textForSearch: currentSearchTextNotWrap)
                }
        })
    }
    
    
    private func updateTableViewFromRealm() {
        guard let allGroupsInRealm = self.allGroupsInRealm else {return}
        
        self.token = allGroupsInRealm.observe { [self]  (changes: RealmCollectionChange) in
                    switch changes {
                    case .initial, .update:
                                    self.tableView.reloadData()
                    case .error(let error):
                        print(error)
                    }
                }
    }
    
    private func loadAndSaveGroupsInRealm(textForSearch:String){
        networkService.groupsSearch(textForSearch: textForSearch, numberGroups: 10, completion: { [weak self] allSearchedGroups in
            guard
                let allSearchGroupsVK = allSearchedGroups
            else {return}
            try? RealmService.delete(object: self!.allGroupsInRealm!)
            try? RealmService.save(items: allSearchGroupsVK)
            self!.tableView.reloadData()
            
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let searchRef = self.ref.child(searchText.lowercased())
            searchRef.setValue(["searchText" : searchText, "idUser" : DataAboutSession.data.userID, "searchNumber": searchNumber])
            searchNumber += 1
            searchFraze = searchText
        }
        else {
            searchFraze = searchText
            try? RealmService.delete(object: self.allGroupsInRealm!)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addGroupWithSegue", sender: nil)
    }
}


