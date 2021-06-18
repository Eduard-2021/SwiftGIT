//
//  FriendsViewTableController.swift
//  VK_PlusHW9.2
//
//  Created by Eduard on 12.05.2021.
//

import UIKit
import RealmSwift



class FriendsViewTableController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {


    @IBOutlet weak var photoTest: UIImageView!
    
    @IBOutlet weak var searchBarForFriends: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
     @IBAction func addRealmObject(_ sender: Any) {
         alertForAddAndDeleteRealmObject(messageRealm: "Введите фамилию и имя нового друга", actionReal: "Добавить")
     }
     @IBAction func deleteRealmObject(_ sender: Any) {
         alertForAddAndDeleteRealmObject(messageRealm: "Введите фамилию друга, который будет удален с Realm", actionReal: "Удалить")
     }
    
    private let networkService = MainNetworkService()
    var users = try? RealmService.load(typeOf: RealmUser.self, sortedKey: "fullName")
    var usersOrigin = try? RealmService.load(typeOf: RealmUserOrigin.self, sortedKey: "fullName")
    var realmUserPhotos = try? RealmService.load(typeOf: RealmUserPhoto.self, sortedKey: "serialNumberPhoto")
    var token: NotificationToken?
    
    static var friendsSorted: [[User]] = [[]]
    
    var friendsSortedWithoutChoose: [[User]] = [[]]
    var searchActive = false
    var deleteActive = false
    var addActive = false
    var elementNumber = 0
    var idNewFriends = 1
    
    var numberOfSectionsAndRows = [0]
    
    var nameOfSectionCharacter = [Character]()
    
    var quickTransitionControl : QuickTransitionControl! = nil
    static let heightQuickTransitionControl: CGFloat = 20
    static let distanceStackQuickTransitionControl: CGFloat = 5
    
    private func updateTableViewFromRealm() {
        guard let users = self.users else {return}
        
        self.token = users.observe { [self]  (changes: RealmCollectionChange) in
                    switch changes {
                    case .initial:
                                    self.tableView.reloadData()
                    case .update(_, let deletions, let insertions, let modifications):
                        if deleteActive || addActive {
                                    deleteActive = false
                                    self.tableView.beginUpdates()
                            if insertions.count != 0 {
                                guard let usersOld = self.users else {return}
                                let olfFriend = usersOld.filter("sectionNumber == %@", 0)
                                guard let numberSection = olfFriend.first?.numberOfSection else {return}
                                var newFriend = usersOld.filter("sectionNumber == %@", -1)
                                guard let idNewFriend = newFriend.first?.id else {return}
                                var usersInRealm = convertUsersFromResult(users)
                                usersInRealm = sortedFriendsFunction(friends: usersInRealm)
                                try? RealmService.save(items: usersInRealm)
                                guard let usersNew = self.users else {return}
                                var rowInsert = 0
                                newFriend = usersNew.filter("id == %@", idNewFriend)
                                guard let sectionInsert = newFriend.first?.sectionNumber else {return}
                                var newUserFound = false
                                for value in usersNew {
                                    if value.sectionNumber == sectionInsert, !newUserFound {
                                    if value.id != idNewFriend {
                                        rowInsert += 1
                                    }
                                    else {newUserFound = true}
                                    }
                                }
                                let usersInRealmOrignal = convertFromRealmUsetToRealUserOrigin(usersInRealm)
                                try? RealmService.save(items: usersInRealmOrignal)
                                if numberSection < usersInRealmOrignal.first!.numberOfSection {
                                    self.tableView.insertSections(IndexSet(arrayLiteral: sectionInsert), with: .left)
                                }
                                
                                self.tableView.insertRows(at: [IndexPath(row: rowInsert, section: sectionInsert)],
                                                         with: .left)
                                addActive = false
                            }
                            
                        if deletions.count != 0 {
                                guard let usersOrigin = self.usersOrigin else {return}
                                guard let numberSection = usersOrigin.first?.numberOfSection else {return}
                                let sectionDelete = usersOrigin[deletions.first!].sectionNumber
                                var rowDelete = 0
                                var foundRow = false
                                for (index,value) in usersOrigin.enumerated() {
                                    if value.sectionNumber == sectionDelete, !foundRow  {
                                        if index != deletions.first {rowDelete += 1} else {foundRow = true}
                                    }
                                }
                                var usersInRealm = convertUsersFromResult(users)
                                usersInRealm = sortedFriendsFunction(friends: usersInRealm)
                                let usersInRealmOrignal = convertFromRealmUsetToRealUserOrigin(usersInRealm)
                                try? RealmService.save(items: usersInRealm)
                                
                                let realm = try? Realm()
                                let userForDelete = realm!.objects(RealmUserOrigin.self).filter("id == %@", usersOrigin[deletions.first!].id)
                                try? RealmService.delete(object: userForDelete)
                                
                                try? RealmService.save(items: usersInRealmOrignal)
                                
                                            self.tableView.deleteRows(at: [IndexPath(row: rowDelete, section: sectionDelete)],
                                                                      with: . left)
                            guard let usersUnwrap = users.first else {return}
                            if numberSection > usersUnwrap.numberOfSection {
                                self.tableView.deleteSections(IndexSet(arrayLiteral: sectionDelete), with: .left)
                            }
                        
//                                    self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
//                                                         with: .automatic)
                                    
                        }
                            self.tableView.endUpdates()
                    quickTransitionControl.removeFromSuperview()
                    quickTransitionSection()
                    }
                    case .error(let error):
                        print(error)
                    }
                }

    }
    
    private func alertForAddAndDeleteRealmObject(messageRealm:String, actionReal:String) {
        let alertController = UIAlertController(title: messageRealm, message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
        })
        let confirmAction = UIAlertAction(title: actionReal, style: .default) { [weak self] action in
            guard let answer = alertController.textFields?[0].text else { return }
            self!.updateRealm(action: actionReal, friendName: answer)
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: {  })
    }
    
    private func updateRealm(action:String, friendName:String){
        if action=="Удалить" {
            deleteActive = true
            guard let users = self.users else {return}
            for (index,value) in users.enumerated() {
                if value.fullName.lowercased().contains(friendName.lowercased()) {
                    let realm = try? Realm()
                    let userForDelete = realm!.objects(RealmUser.self).filter("id == %@", value.id)
                    try? RealmService.delete(object: userForDelete)
                }
            }
        }
        else {
            addActive = true
            let newUser = RealmUser()
            newUser.fullName = friendName
            newUser.sectionNumber = -1
            newUser.id = idNewFriends
            newUser.userAvatarURL = "https://sun6-20.userapi.com/s/v1/ig1/cb6vQ0d0qoyH04eqal1PWuB55lkk2MgkwWzQqWLhYE_Gtnlj4Gc-N9oFcawXdOPhHeSHtjir.jpg?size=200x0&quality=96&crop=0,0,900,900&ava=1"
            try? RealmService.save(items: [newUser])
            idNewFriends += 1
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.getUserFriends { [weak self] vkFriends, vkFriendsUnsorted in
            guard
                let self = self,
                var friends = vkFriends,
                var friendsOrigin = vkFriendsUnsorted
            else
            { return }
            friends = self.sortedFriendsFunction(friends: friends)
            try? RealmService.save(items: friends)
            friendsOrigin = self.saveOriginFriends(friends, friendsOrigin)
            try? RealmService.save(items: friendsOrigin)
            self.tableView.reloadData()
            self.updateTableViewFromRealm()
            self.quickTransitionSection()
        }

        searchBarForFriends.delegate = self
        let nib = UINib(nibName: "FriendAndGroupCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendAndGroupCell")
        createRecognize()
        
    }
    
    private func convertUsersFromResult(_ friends: Results<RealmUser>) -> [RealmUser] {
        var friendsInRealm = [RealmUser]()
        for (index,value) in friends.enumerated() {
            friendsInRealm.append(RealmUser())
            friendsInRealm[index].firstName = value.firstName
            friendsInRealm[index].fullName = value.fullName
            friendsInRealm[index].id = value.id
            friendsInRealm[index].images = value.images
            friendsInRealm[index].lastName = value.lastName
            friendsInRealm[index].numberOfSection = value.numberOfSection
            friendsInRealm[index].sectionNumber = value.sectionNumber
            friendsInRealm[index].userAvatarURL = value.userAvatarURL
        }
        return friendsInRealm
    }
    
    private func convertUsersOrignalFromResult(_ friends: Results<RealmUserOrigin>) -> [RealmUserOrigin] {
        let friendsInRealm = [RealmUserOrigin()]
        for (index,value) in friends.enumerated() {
            friendsInRealm[index].firstName = value.firstName
            friendsInRealm[index].fullName = value.fullName
            friendsInRealm[index].id = value.id
            friendsInRealm[index].images = value.images
            friendsInRealm[index].lastName = value.lastName
            friendsInRealm[index].numberOfSection = value.numberOfSection
            friendsInRealm[index].sectionNumber = value.sectionNumber
            friendsInRealm[index].userAvatarURL = value.userAvatarURL
        }
        return friendsInRealm
    }
    
    private func  convertFromRealmUsetToRealUserOrigin(_ friends: [RealmUser]) -> [RealmUserOrigin] {
        var friendsOrigin = [RealmUserOrigin]()
        for (index,value) in friends.enumerated() {
            friendsOrigin.append(RealmUserOrigin())
            friendsOrigin[index].firstName = value.firstName
            friendsOrigin[index].fullName = value.fullName
            friendsOrigin[index].id = value.id
            friendsOrigin[index].images = value.images
            friendsOrigin[index].lastName = value.lastName
            friendsOrigin[index].numberOfSection = value.numberOfSection
            friendsOrigin[index].sectionNumber = value.sectionNumber
            friendsOrigin[index].userAvatarURL = value.userAvatarURL
        }
        return friendsOrigin
    }
    
    
    private func saveOriginFriends(_ friends: [RealmUser], _ friendsOrigin: [RealmUserOrigin]) -> [RealmUserOrigin] {
        for (index,value) in friends.enumerated() {
            friendsOrigin[index].firstName = value.firstName
            friendsOrigin[index].fullName = value.fullName
            friendsOrigin[index].id = value.id
            friendsOrigin[index].images = value.images
            friendsOrigin[index].lastName = value.lastName
            friendsOrigin[index].numberOfSection = value.numberOfSection
            friendsOrigin[index].sectionNumber = value.sectionNumber
            friendsOrigin[index].userAvatarURL = value.userAvatarURL
        }
        return friendsOrigin
    }
    
    
    
    private func loadOriginFriends(_ friendsOrigin: [RealmUserOrigin]) -> [RealmUser] {
        var friends = [RealmUser]()
        for (index,value) in friendsOrigin.enumerated() {
            friends.append(RealmUser())
            friends[index].firstName = value.firstName
            friends[index].fullName = value.fullName
            friends[index].id = value.id
            friends[index].images = value.images
            friends[index].lastName = value.lastName
            friends[index].numberOfSection = value.numberOfSection
            friends[index].sectionNumber = value.sectionNumber
            friends[index].userAvatarURL = value.userAvatarURL
        }
        return friends
    }
    
    
    
    private func sortedFriendsFunction(friends:[RealmUser]) -> [RealmUser] {
        let friendsSorted = friends.sorted(by: { (i1, i2) -> Bool in i1.fullName<i2.fullName})
        var numberOfSections = 0
        for (index,value) in friendsSorted.enumerated() {
            if index != friendsSorted.count-1 {
            if value.fullName.first != friendsSorted[index+1].fullName.first {
                friendsSorted[index].sectionNumber = numberOfSections
                numberOfSections += 1
            }
            else {
                friendsSorted[index].sectionNumber = numberOfSections
            }
            }
            else {
                friendsSorted[index].sectionNumber = numberOfSections
            }
        }
            for value in friendsSorted {
                value.numberOfSection = numberOfSections+1
            }
       return friendsSorted
    }
    
    
    private func createRecognize() {
        let tapRecog = UITapGestureRecognizer()
        tapRecog.delegate = self
        let longPressRecog = UILongPressGestureRecognizer()
        longPressRecog.delegate = self
        let panRecog = UIPanGestureRecognizer()
        panRecog.delegate = self
        let swipeRecog = UISwipeGestureRecognizer()
        swipeRecog.delegate = self
        
        tableView.addGestureRecognizer(tapRecog)
        tableView.addGestureRecognizer(longPressRecog)
        tableView.addGestureRecognizer(panRecog)
        tableView.addGestureRecognizer(swipeRecog)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return users?.first?.numberOfSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        for value in users!{
            if value.sectionNumber == section {
                numberOfRows += 1
            }
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var elementNumber = 0
        while users?[elementNumber].sectionNumber !=  indexPath.section {elementNumber += 1 }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendAndGroupCell", for: indexPath) as? FriendAndGroupCell,
              let currentFriend = users?[elementNumber+indexPath.row]
              else {return UITableViewCell()}
        
        cell.configure(imageURL: currentFriend.userAvatarURL, name: currentFriend.fullName)
        return cell
        }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SeePhoto", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard
                segue.identifier == "SeePhoto",
                let indexPath = sender as? IndexPath,
                let friendsTableController = segue.destination as? FriendInfoCollectionController
                else {return}
        var elementNumber = 0
        while users?[elementNumber].sectionNumber !=  indexPath.section {elementNumber += 1 }
        friendsTableController.selectedUser = users?[elementNumber + indexPath.row].id
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        HeightOfSell.middle.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var elementNumber = 0
        while users?[elementNumber].sectionNumber != section {elementNumber += 1 }
        if users?.first?.numberOfSection != 0 {
            let header = FriendAndGroupsHeader()
            if let firstChapter = users?[elementNumber].fullName.first {
            header.configure(with: String(firstChapter))
            }
            return header
        }
        else {return nil}
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var choosedFriendsFromOrigin = [RealmUserOrigin]()
        for value in usersOrigin! {
            if value.fullName.lowercased().contains(searchText.lowercased()) {
                choosedFriendsFromOrigin.append(value)
            }
        }

        if searchText != "" {
                    if let unSortedUsers =  self.users {
                     try? RealmService.delete(object: unSortedUsers)
                    }
            var choosedFriends=loadOriginFriends(choosedFriendsFromOrigin)
            choosedFriends = self.sortedFriendsFunction(friends: choosedFriends)
        try? RealmService.save(items: choosedFriends)
        } else {
            if let unSortedUsers =  self.users {
             try? RealmService.delete(object: unSortedUsers)
            }
            var choosedFriendsOriginal = [RealmUserOrigin]()
            for value in usersOrigin! {
                choosedFriendsOriginal.append(value)
                }
            
        var choosedFriends=loadOriginFriends(choosedFriendsOriginal)
        choosedFriends = self.sortedFriendsFunction(friends: choosedFriends)
        try? RealmService.save(items: choosedFriends)
        }
        
        quickTransitionControl.removeFromSuperview()
        quickTransitionSection()
        tableView.reloadData()
    }

    func quickTransitionSection() {
        var nameOfSection = [String]()
        
        
//        for section in FriendsViewTableController.friendsSorted {
//            if section.count != 0 {
//            nameOfSection.append("\(section[0].fullName.first!)")
//            }
//        }
//
        guard let users = users else {return}
        
        var sectionNumber = -1
        for section in users {
            if section.sectionNumber != sectionNumber {
                nameOfSection.append("\(section.fullName.first!)")
                sectionNumber = section.sectionNumber
            }
        }
        
        nameOfSectionCharacter = nameOfSection.map({Character($0)})
        
        let heightOfStackControls = (FriendsViewTableController.distanceStackQuickTransitionControl+FriendsViewTableController.heightQuickTransitionControl)*CGFloat(nameOfSectionCharacter.count)
        
        let pozitionStackX = view.frame.maxX-FriendsViewTableController.heightQuickTransitionControl*1.5
        let pozitionStackY = view.bounds.midY - heightOfStackControls/2
    
        quickTransitionControl = QuickTransitionControl(namesOfSections: nameOfSectionCharacter, frame: CGRect(x: pozitionStackX, y: pozitionStackY, width: FriendsViewTableController.heightQuickTransitionControl, height: heightOfStackControls))
        
        
        quickTransitionControl.addTarget(self, action: #selector(goToSection), for: .valueChanged)
        

        func createBackground(){
            let factor = (CGFloat(nameOfSectionCharacter.count)-1)*(FriendsViewTableController.distanceStackQuickTransitionControl+FriendsViewTableController.heightQuickTransitionControl)
            let backGround = CAShapeLayer()
            let pozzitionBackGroundX : CGFloat = pozitionStackX - FriendsViewTableController.heightQuickTransitionControl * 0.5
            let pozzitionBackGroundY = pozitionStackY - FriendsViewTableController.heightQuickTransitionControl
            
            backGround.frame = CGRect(x: pozzitionBackGroundX, y: pozzitionBackGroundY, width: 0, height: 0)
            
            let bezieBackGround = UIBezierPath()
            
            let startPoint = CGPoint(x: FriendsViewTableController.heightQuickTransitionControl*1.75, y: 0)
            bezieBackGround.move(to: startPoint)
            bezieBackGround.addCurve(to: CGPoint(x: 0, y: FriendsViewTableController.heightQuickTransitionControl*1.5 + factor/2),
                                controlPoint1: CGPoint(x: 0, y: 0),
                                controlPoint2: CGPoint(x: 0, y: FriendsViewTableController.heightQuickTransitionControl/20))
            bezieBackGround.addCurve(to: CGPoint(x: FriendsViewTableController.heightQuickTransitionControl*1.75, y: FriendsViewTableController.heightQuickTransitionControl*3 + factor),
                                     controlPoint1: CGPoint(x: 0, y: (FriendsViewTableController.heightQuickTransitionControl*3 + factor) - FriendsViewTableController.heightQuickTransitionControl/20),
                                controlPoint2: CGPoint(x: 0, y: FriendsViewTableController.heightQuickTransitionControl*3 + factor))
            bezieBackGround.addCurve(to: startPoint,
                                     controlPoint1: CGPoint(x: FriendsViewTableController.heightQuickTransitionControl*1.75, y: FriendsViewTableController.heightQuickTransitionControl*1.5 + factor),
                                controlPoint2: CGPoint(x:  FriendsViewTableController.heightQuickTransitionControl*1.75, y: FriendsViewTableController.heightQuickTransitionControl*1.5 + factor))
            
            backGround.path = bezieBackGround.cgPath
            backGround.fillColor = UIColor.white.cgColor
            view.layer.addSublayer(backGround)
        
        }
        createBackground()
        view.addSubview(quickTransitionControl)
    
    }
    
    @objc private func goToSection(){
        guard let activeSection = quickTransitionControl.namesOfSections.firstIndex(of: quickTransitionControl.selectedSection!) else {return}
        tableView.scrollToRow(at: IndexPath(row: 0, section: activeSection), at: .top, animated: true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let selectedSection = quickTransitionControl.selectedSection {
        quickTransitionControl.setOfButtons[selectedSection]?.isSelected = false
        quickTransitionControl.setOfButtons[selectedSection]?.backgroundColor = .systemGray3
        }
        return false
    }
    

}



























////
////  FriendsViewTableController.swift
////  VK_PlusHW9.2
////
////  Created by Eduard on 12.05.2021.
////
//
//import UIKit
//import RealmSwift
//
//
//
//class FriendsViewTableController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {
//
//
//    @IBOutlet weak var photoTest: UIImageView!
//
//    @IBOutlet weak var searchBarForFriends: UISearchBar!
//    @IBOutlet weak var tableView: UITableView!
//
//    private let networkService = MainNetworkService()
//    var users = try? RealmService.load(typeOf: RealmUser.self, sortedKey: "fullName")
//    var usersOrigin = try? RealmService.load(typeOf: RealmUserOrigin.self, sortedKey: "fullName")
//    var realmUserPhotos = try? RealmService.load(typeOf: RealmUserPhoto.self, sortedKey: "serialNumberPhoto")
//
//    static var friendsSorted: [[User]] = [[]]
//
//    var friendsSortedWithoutChoose: [[User]] = [[]]
//    var searchActive = false
//    var elementNumber = 0
//
//    var numberOfSectionsAndRows = [0]
//
//    var nameOfSectionCharacter = [Character]()
//
//    var quickTransitionControl : QuickTransitionControl! = nil
//    static let heightQuickTransitionControl: CGFloat = 20
//    static let distanceStackQuickTransitionControl: CGFloat = 5
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        networkService.getUserFriends { [weak self] vkFriends, vkFriendsUnsorted in
//            guard
//                let self = self,
//                var friends = vkFriends,
//                var friendsOrigin = vkFriendsUnsorted
//            else
//            { return }
//            friends = self.sortedFriendsFunction(friends: friends)
//            try? RealmService.save(items: friends)
//            friendsOrigin = self.saveOriginFriends(friends, friendsOrigin)
//            try? RealmService.save(items: friendsOrigin)
//            self.tableView.reloadData()
//        }
//
//        searchBarForFriends.delegate = self
//        let nib = UINib(nibName: "FriendAndGroupCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "FriendAndGroupCell")
//        quickTransitionSection()
//        createRecognize()
//    }
//
//    private func saveOriginFriends(_ friends: [RealmUser], _ friendsOrigin: [RealmUserOrigin]) -> [RealmUserOrigin] {
//        for (index,value) in friends.enumerated() {
//            friendsOrigin[index].firstName = value.firstName
//            friendsOrigin[index].fullName = value.fullName
//            friendsOrigin[index].id = value.id
//            friendsOrigin[index].images = value.images
//            friendsOrigin[index].lastName = value.lastName
//            friendsOrigin[index].numberOfSection = value.numberOfSection
//            friendsOrigin[index].sectionNumber = value.sectionNumber
//            friendsOrigin[index].userAvatarURL = value.userAvatarURL
//        }
//        return friendsOrigin
//    }
//
//    private func loadOriginFriends(_ friendsOrigin: [RealmUserOrigin]) -> [RealmUser] {
//        var friends = [RealmUser]()
//        for (index,value) in friendsOrigin.enumerated() {
//            friends.append(RealmUser())
//            friends[index].firstName = value.firstName
//            friends[index].fullName = value.fullName
//            friends[index].id = value.id
//            friends[index].images = value.images
//            friends[index].lastName = value.lastName
//            friends[index].numberOfSection = value.numberOfSection
//            friends[index].sectionNumber = value.sectionNumber
//            friends[index].userAvatarURL = value.userAvatarURL
//        }
//        return friends
//    }
//
//
//
//    private func sortedFriendsFunction(friends:[RealmUser]) -> [RealmUser] {
//        let friendsSorted = friends.sorted(by: { (i1, i2) -> Bool in i1.fullName<i2.fullName})
//        var numberOfSections = 0
//        for (index,value) in friendsSorted.enumerated() {
//            if index != friendsSorted.count-1 {
//            if value.fullName.first != friendsSorted[index+1].fullName.first {
//                friendsSorted[index].sectionNumber = numberOfSections
//                numberOfSections += 1
//            }
//            else {
//                friendsSorted[index].sectionNumber = numberOfSections
//            }
//            }
//            else {
//                friendsSorted[index].sectionNumber = numberOfSections
//            }
//        }
//            for value in friendsSorted {
//                value.numberOfSection = numberOfSections+1
//            }
//       return friendsSorted
//    }
//
//
//    private func createRecognize() {
//        let tapRecog = UITapGestureRecognizer()
//        tapRecog.delegate = self
//        let longPressRecog = UILongPressGestureRecognizer()
//        longPressRecog.delegate = self
//        let panRecog = UIPanGestureRecognizer()
//        panRecog.delegate = self
//        let swipeRecog = UISwipeGestureRecognizer()
//        swipeRecog.delegate = self
//
//        tableView.addGestureRecognizer(tapRecog)
//        tableView.addGestureRecognizer(longPressRecog)
//        tableView.addGestureRecognizer(panRecog)
//        tableView.addGestureRecognizer(swipeRecog)
//    }
//
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return users?.first?.numberOfSection ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var numberOfRows = 0
//        for value in users!{
//            if value.sectionNumber == section {
//                numberOfRows += 1
//            }
//        }
//        return numberOfRows
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var elementNumber = 0
//        while users?[elementNumber].sectionNumber !=  indexPath.section {elementNumber += 1 }
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendAndGroupCell", for: indexPath) as? FriendAndGroupCell,
//              let currentFriend = users?[elementNumber+indexPath.row]
//              else {return UITableViewCell()}
//
//        cell.configure(imageURL: currentFriend.userAvatarURL, name: currentFriend.fullName)
//        return cell
//        }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "SeePhoto", sender: indexPath)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            guard
//                segue.identifier == "SeePhoto",
//                let indexPath = sender as? IndexPath,
//                let friendsTableController = segue.destination as? FriendInfoCollectionController
//                else {return}
//        var elementNumber = 0
//        while users?[elementNumber].sectionNumber !=  indexPath.section {elementNumber += 1 }
//        friendsTableController.selectedUser = users?[elementNumber + indexPath.row].id
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        30.0
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        HeightOfSell.middle.rawValue
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var elementNumber = 0
//        while users?[elementNumber].sectionNumber != section {elementNumber += 1 }
//        if users?.first?.numberOfSection != 0 {
//            let header = FriendAndGroupsHeader()
//            if let firstChapter = users?[elementNumber].fullName.first {
//            header.configure(with: String(firstChapter))
//            }
//            return header
//        }
//        else {return nil}
//    }
//
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        var choosedFriendsFromOrigin = [RealmUserOrigin]()
//        for value in usersOrigin! {
//            if value.fullName.lowercased().contains(searchText.lowercased()) {
//                choosedFriendsFromOrigin.append(value)
//            }
//        }
//
//        if searchText != "" {
//                    if let unSortedUsers =  self.users {
//                     try? RealmService.delete(object: unSortedUsers)
//                    }
//            var choosedFriends=loadOriginFriends(choosedFriendsFromOrigin)
//            choosedFriends = self.sortedFriendsFunction(friends: choosedFriends)
//        try? RealmService.save(items: choosedFriends)
//        } else {
//            if let unSortedUsers =  self.users {
//             try? RealmService.delete(object: unSortedUsers)
//            }
//            var choosedFriendsOriginal = [RealmUserOrigin]()
//            for value in usersOrigin! {
//                choosedFriendsOriginal.append(value)
//                }
//
//        var choosedFriends=loadOriginFriends(choosedFriendsOriginal)
//        choosedFriends = self.sortedFriendsFunction(friends: choosedFriends)
//        try? RealmService.save(items: choosedFriends)
//        }
//
////        quickTransitionControl.removeFromSuperview()
////        quickTransitionSection()
//        tableView.reloadData()
//    }
//
//    func quickTransitionSection() {
//        var nameOfSection = [String]()
//
//
////        for section in FriendsViewTableController.friendsSorted {
////            if section.count != 0 {
////            nameOfSection.append("\(section[0].fullName.first!)")
////            }
////        }
////
//        guard let users = users else {return}
//
//        var sectionNumber = -1
//        for section in users {
//            if section.sectionNumber != sectionNumber {
//                nameOfSection.append("\(section.fullName.first!)")
//                sectionNumber = section.sectionNumber
//            }
//        }
//
//        nameOfSectionCharacter = nameOfSection.map({Character($0)})
//
//        let heightOfStackControls = (FriendsViewTableController.distanceStackQuickTransitionControl+FriendsViewTableController.heightQuickTransitionControl)*CGFloat(nameOfSectionCharacter.count)
//
//        let pozitionStackX = view.frame.maxX-FriendsViewTableController.heightQuickTransitionControl*1.5
//        let pozitionStackY = view.bounds.midY - heightOfStackControls/2
//
//        quickTransitionControl = QuickTransitionControl(namesOfSections: nameOfSectionCharacter, frame: CGRect(x: pozitionStackX, y: pozitionStackY, width: FriendsViewTableController.heightQuickTransitionControl, height: heightOfStackControls))
//
//
//        quickTransitionControl.addTarget(self, action: #selector(goToSection), for: .valueChanged)
//
//
//        func createBackground(){
//            let factor = (CGFloat(nameOfSectionCharacter.count)-1)*(FriendsViewTableController.distanceStackQuickTransitionControl+FriendsViewTableController.heightQuickTransitionControl)
//            let backGround = CAShapeLayer()
//            let pozzitionBackGroundX : CGFloat = pozitionStackX - FriendsViewTableController.heightQuickTransitionControl * 0.5
//            let pozzitionBackGroundY = pozitionStackY - FriendsViewTableController.heightQuickTransitionControl
//
//            backGround.frame = CGRect(x: pozzitionBackGroundX, y: pozzitionBackGroundY, width: 0, height: 0)
//
//            let bezieBackGround = UIBezierPath()
//
//            let startPoint = CGPoint(x: FriendsViewTableController.heightQuickTransitionControl*1.75, y: 0)
//            bezieBackGround.move(to: startPoint)
//            bezieBackGround.addCurve(to: CGPoint(x: 0, y: FriendsViewTableController.heightQuickTransitionControl*1.5 + factor/2),
//                                controlPoint1: CGPoint(x: 0, y: 0),
//                                controlPoint2: CGPoint(x: 0, y: FriendsViewTableController.heightQuickTransitionControl/20))
//            bezieBackGround.addCurve(to: CGPoint(x: FriendsViewTableController.heightQuickTransitionControl*1.75, y: FriendsViewTableController.heightQuickTransitionControl*3 + factor),
//                                     controlPoint1: CGPoint(x: 0, y: (FriendsViewTableController.heightQuickTransitionControl*3 + factor) - FriendsViewTableController.heightQuickTransitionControl/20),
//                                controlPoint2: CGPoint(x: 0, y: FriendsViewTableController.heightQuickTransitionControl*3 + factor))
//            bezieBackGround.addCurve(to: startPoint,
//                                     controlPoint1: CGPoint(x: FriendsViewTableController.heightQuickTransitionControl*1.75, y: FriendsViewTableController.heightQuickTransitionControl*1.5 + factor),
//                                controlPoint2: CGPoint(x:  FriendsViewTableController.heightQuickTransitionControl*1.75, y: FriendsViewTableController.heightQuickTransitionControl*1.5 + factor))
//
//            backGround.path = bezieBackGround.cgPath
//            backGround.fillColor = UIColor.white.cgColor
//            view.layer.addSublayer(backGround)
//
//        }
//        createBackground()
//        view.addSubview(quickTransitionControl)
//
//    }
//
//    @objc private func goToSection(){
//        guard let activeSection = quickTransitionControl.namesOfSections.firstIndex(of: quickTransitionControl.selectedSection!) else {return}
//        tableView.scrollToRow(at: IndexPath(row: 0, section: activeSection), at: .top, animated: true)
//    }
//
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if let selectedSection = quickTransitionControl.selectedSection {
//        quickTransitionControl.setOfButtons[selectedSection]?.isSelected = false
//        quickTransitionControl.setOfButtons[selectedSection]?.backgroundColor = .systemGray3
//        }
//        return false
//    }
//
//
//}
