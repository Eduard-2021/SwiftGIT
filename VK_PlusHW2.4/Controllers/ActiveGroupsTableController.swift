//
//  ActiveGroupTableController.swift
//  VK_PlusHW3
//
//  Created by Eduard on 07.04.2021.
//

import UIKit

class ActiveGroupsTableController: UITableViewController, UISearchBarDelegate {
    
//    var activeGroups = [
//    Group(imageGroup: UIImage(named: "Audi")!, nameGroup: "Группа любителей ауди"),
//    Group(imageGroup: UIImage(named: "Mercedes")!, nameGroup: "Группа любителей мерседесов"),
//    ]
    @IBOutlet weak var searchBarText: UISearchBar!
    
    var choosedActiveGroups: [Group]!
    var searchActive = false
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return choosedActiveGroups.count
        }
        else {
            return activeGroups.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var workArray = activeGroups
        if searchActive {workArray = choosedActiveGroups}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendAndGroupCell", for: indexPath) as! FriendAndGroupCell
        cell.imageOfFriendOrGroup.image = workArray[indexPath.row].imageGroup
        cell.nameOfFriendOrGroup.text = workArray[indexPath.row].nameGroup
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    
    @IBAction func addGroup(segue: UIStoryboardSegue){
            guard
                segue.identifier == "addGroupWithSegue",
                let allGroupsTableController = segue.source as? AllGroupsTableController,
                let indexPath = allGroupsTableController.tableView.indexPathForSelectedRow
            else {return}
            if !activeGroups.contains(allGroups[indexPath.row]) {
                activeGroups.append(allGroups[indexPath.row])
            tableView.reloadData()
            }
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            if searchActive {
                activeGroups.remove(at: activeGroups.firstIndex(of: choosedActiveGroups[indexPath.row])!)
                choosedActiveGroups.remove(at: indexPath.row)
            }
            else {
                activeGroups.remove(at: indexPath.row)
                
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
        if searchText != "" {
            searchActive = true
        }
        else {
            searchActive = false
            
        }
        choosedActiveGroups = activeGroups
        var newChoosedActiveGroups = [Group]()
        
        for group in choosedActiveGroups {
            if group.nameGroup.lowercased().contains(searchText.lowercased()) {
                newChoosedActiveGroups.append(group)
            }
        }
        if newChoosedActiveGroups.count != 0 {
            choosedActiveGroups = newChoosedActiveGroups
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FriendAndGroupCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendAndGroupCell")
        searchBarText.delegate = self
        choosedActiveGroups = activeGroups
        navigationController?.delegate = self
        
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
