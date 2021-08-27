//
//  ActiveGroupTableController.swift
//  VK_PlusHW3
//
//  Created by Eduard on 07.04.2021.
//

import UIKit
import RealmSwift

class ActiveGroupsTableController: UITableViewController, UISearchBarDelegate {
    
    private let networkService = MainNetworkService()
    private let networkServiceProxy = MainNetworkServiceProxy(mainNetworkService: MainNetworkService())
    
    var usersGroupsInRealm = try? RealmService.load(typeOf: RealmActiveGroups.self, sortedKey: "idGroup")
    var usersGroupsInRealmOrigin = try? RealmService.load(typeOf: RealmActiveGroupsOrigin.self, sortedKey: "idGroup")
    var token: NotificationToken?
    
    @IBOutlet weak var searchBarText: UISearchBar!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return usersGroupsInRealm?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let workArray = usersGroupsInRealm else {return UITableViewCell()}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendAndGroupCell", for: indexPath) as! FriendAndGroupCell
        cell.configure(imageURL: workArray[indexPath.row].imageGroupURL, name: workArray[indexPath.row].nameGroup)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    
    @IBAction func addGroup(segue: UIStoryboardSegue){
            guard
                segue.identifier == "addGroupWithSegue",
                let allGroupsTableController = segue.source as? AllGroupsTableController,
                let indexPath = allGroupsTableController.tableView.indexPathForSelectedRow
            else {return}
        
        let newGroup = RealmActiveGroups()
//        newGroup.idGroup = allGroupsTableController.allGroupsInRealm![indexPath.row].idGroup
//        newGroup.imageGroupURL = allGroupsTableController.allGroupsInRealm![indexPath.row].imageGroupURL
//        newGroup.nameGroup = allGroupsTableController.allGroupsInRealm![indexPath.row].nameGroup
        
        newGroup.idGroup = allGroupsTableController.allGroupsForAdapter[indexPath.row].idGroup
        newGroup.imageGroupURL = allGroupsTableController.allGroupsForAdapter [indexPath.row].imageGroupURL
        newGroup.nameGroup = allGroupsTableController.allGroupsForAdapter[indexPath.row].nameGroup
        
        if !usersGroupsInRealm!.contains(newGroup) {
            try? RealmService.save(items: [newGroup])
            tableView.reloadData()
            }
    }

    
    private func updateTableViewFromRealm() {
        guard let usersGroupsInRealm = self.usersGroupsInRealm else {return}
        
        self.token = usersGroupsInRealm.observe { [self]  (changes: RealmCollectionChange) in
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
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        if editingStyle == .delete {
            if let groupForDelete = usersGroupsInRealm?[indexPath.row] {
                try! realm.write {
                                realm.delete(groupForDelete)
                            }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        HeightOfSell.middle.rawValue
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var choosedActiveGroupsFromOrigin = [RealmActiveGroupsOrigin]()
        guard let usersGroupsOriginUnwrap = usersGroupsInRealmOrigin else {return}
        for value in usersGroupsOriginUnwrap {
            if value.nameGroup.lowercased().contains(searchText.lowercased()){
                choosedActiveGroupsFromOrigin.append(value)
            }
        }
        
        if searchText != "" {
            guard let usersGroupsUnwrap = usersGroupsInRealm else {return}
            try? RealmService.delete(object: usersGroupsUnwrap)
            let choosedActiveGroups = self.loadOriginActiveGroups(choosedActiveGroupsFromOrigin)
            try? RealmService.save(items: choosedActiveGroups)
        }
        else {
            guard let usersGroupsUnwrap = usersGroupsInRealm else {return}
            try? RealmService.delete(object: usersGroupsUnwrap)
            choosedActiveGroupsFromOrigin = []
            for value in usersGroupsOriginUnwrap {
                choosedActiveGroupsFromOrigin.append(value)
            }
            let choosedActiveGroups = self.loadOriginActiveGroups(choosedActiveGroupsFromOrigin)
            try? RealmService.save(items: choosedActiveGroups)
        }
        
        tableView.reloadData()
    }
    
    private func loadOriginActiveGroups(_ usersGroupsInRealm: [RealmActiveGroupsOrigin]) -> [RealmActiveGroups] {
        var userGroups = [RealmActiveGroups]()
        for (index,value) in usersGroupsInRealm.enumerated() {
            userGroups.append(RealmActiveGroups())
            userGroups[index].idGroup = value.idGroup
            userGroups[index].imageGroupURL = value.imageGroupURL
            userGroups[index].nameGroup = value.nameGroup
        }
        return userGroups
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FriendAndGroupCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendAndGroupCell")
        searchBarText.delegate = self
        loadUserGroupsInRealm()
        navigationController?.delegate = self
        
    }
    
    private func loadUserGroupsInRealm() {
            networkServiceProxy.getGroupsOfUser(userId: DataAboutSession.data.userID) {[weak self] userGroupsVK, userGroupsVKOrigin in
                guard
                    let vkUserGroups = userGroupsVK,
                    let vkUserGroupsOrigin = userGroupsVKOrigin
                else { return }
                try? RealmService.save(items: vkUserGroups)
                try? RealmService.save(items: vkUserGroupsOrigin)
                self!.tableView.reloadData()
                self!.updateTableViewFromRealm()
            }
    }
}


extension ActiveGroupsTableController : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return AnimationPop()
        case .push:
            return AnimationPush()
        default:
            return nil
        }
    }
}
