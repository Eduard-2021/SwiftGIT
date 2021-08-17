//
//  LoadAllGroupsWithAdapter.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 16.08.2021.
//

import UIKit
import RealmSwift

protocol ReloadAllGroupsController {
    func reloadController()
}

// С помощью паттерна Adapter организован перехват(получение) данных о всех групах, удовлетворяющих поисковому запросу, и передача этих данных через замыкание в основной контроллер (AllGroupsTableController) для отображения на экране (для обновления экрана также используется паттерн Delegate)

class LoadAllGroupsWithAdapter {
    public static let shared = LoadAllGroupsWithAdapter()
    private init(){}
    private var allGroupsInRealm = try? RealmService.load(typeOf: RealmAllGroups.self, sortedKey: "idGroup")
    private var delegateForAllGroups: ReloadAllGroupsController!
    private var token: NotificationToken?
    
    func loadAllGroups(textForSearchInAllGroups: String, vc: UITableViewController, complition: @escaping ([AllGroupsForAdapter]) -> Void) {
        delegateForAllGroups = vc as! AllGroupsTableController
        
        if textForSearchInAllGroups != "" {
        textForSearch = textForSearchInAllGroups
            loadAndSaveAllGroupsInRealm(textForSearchInAllGroups: textForSearch)}
        else {
            guard let groupsForDelete = self.allGroupsInRealm else {return}
            try? RealmService.delete(object: groupsForDelete)
        }

         guard let allGroupsInRealm = self.allGroupsInRealm else {return}

             self.token = allGroupsInRealm.observe { [weak self]  (changes: RealmCollectionChange) in
                 guard let self=self else {return}
                 var allGroupsForAdapter=[AllGroupsForAdapter]()
                         switch changes {
                         case .initial(let newGroups):
                             for newGroup in newGroups {
                                 allGroupsForAdapter.append(self.convertType(oneNewGroupInRealm: newGroup))
                             }
                            complition(allGroupsForAdapter)
                             self.delegateForAllGroups.reloadController()
                         case .update(let newGroups, _,_,_):
                             for newGroup in newGroups {
                                 allGroupsForAdapter.append(self.convertType(oneNewGroupInRealm: newGroup))
                             }
                            complition(allGroupsForAdapter)
                             self.delegateForAllGroups.reloadController()
                            
                         case .error(let error):
                             print(error)
                         }
                     }
    }
    
    func loadAllGroupsAfterSearch(textForSearchInAllGroups: String) {
        if textForSearchInAllGroups != "" {
        textForSearch = textForSearchInAllGroups
            loadAndSaveAllGroupsInRealm(textForSearchInAllGroups: textForSearch)}
        else {
            guard let groupsForDelete = self.allGroupsInRealm else {return}
            try? RealmService.delete(object: groupsForDelete)
        }
    }
    
    private func convertType(oneNewGroupInRealm: RealmAllGroups) -> AllGroupsForAdapter {
        let oneGroupForAdapter = AllGroupsForAdapter()
        oneGroupForAdapter.idGroup = oneNewGroupInRealm.idGroup
        oneGroupForAdapter.imageGroupURL = oneNewGroupInRealm.imageGroupURL
        oneGroupForAdapter.nameGroup = oneNewGroupInRealm.nameGroup
        return oneGroupForAdapter
    }
    
    private func loadAndSaveAllGroupsInRealm(textForSearchInAllGroups : String){
        MainNetworkService().groupsSearch(textForSearch: textForSearchInAllGroups, numberGroups: 10, completion: { allSearchedGroups in
            guard
                let allSearchGroupsVK = allSearchedGroups
            else {return}
            guard let groupsForDelete = self.allGroupsInRealm else {return}
            try? RealmService.delete(object: groupsForDelete)
            try? RealmService.save(items: allSearchGroupsVK)
        })
    }
    
}
