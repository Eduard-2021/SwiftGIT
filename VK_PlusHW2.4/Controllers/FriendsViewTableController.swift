//
//  FriendsViewTableController.swift
//  VK_PlusHW9.2
//
//  Created by Eduard on 12.05.2021.
//

import UIKit

class FriendsViewTableController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {


    @IBOutlet weak var photoTest: UIImageView!
    
    @IBOutlet weak var searchBarForFriends: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    static var friendsSorted: [[User]] = [[]]
    
    var friendsSortedWithoutChoose: [[User]] = [[]]
    var searchActive = false
    
    var numberOfSectionsAndRows = [0]
    
    var nameOfSectionCharacter = [Character]()
    
    var quickTransitionControl : QuickTransitionControl! = nil
    static let heightQuickTransitionControl: CGFloat = 20
    static let distanceStackQuickTransitionControl: CGFloat = 5
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotoFromNet()
        searchBarForFriends.delegate = self
        let nib = UINib(nibName: "FriendAndGroupCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendAndGroupCell")
        
        friends =  friends.sorted(by: { (i1, i2) -> Bool in i1.nameSurnameUser<i2.nameSurnameUser})
        
        sortedFriends()
        friendsSortedWithoutChoose = FriendsViewTableController.friendsSorted
        quickTransitionSection()
        createRecognize()
        
    }
    
    private func sortedFriends(){
        var numberOfSections = 0
        if FriendsViewTableController.friendsSorted.count == 1 {
                for (index,value) in friends.enumerated() {
                    if index != friends.count-1 {
                    if value.nameSurnameUser.first != friends[index+1].nameSurnameUser.first {
                        FriendsViewTableController.friendsSorted.append([])
                        FriendsViewTableController.friendsSorted[numberOfSections].append(friends[index])
                        numberOfSections += 1
                        }
                    else {
                        FriendsViewTableController.friendsSorted[numberOfSections].append(friends[index])
                    }
                    }
                    else {
                        FriendsViewTableController.friendsSorted[numberOfSections].append(friends[index])
                    }
                    }
        }
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
        return FriendsViewTableController.friendsSorted.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FriendsViewTableController.friendsSorted[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FriendAndGroupCell", for: indexPath) as? FriendAndGroupCell {
            cell.imageOfFriendOrGroup.image = FriendsViewTableController.friendsSorted[indexPath.section][indexPath.row].avatar
            cell.nameOfFriendOrGroup.text = FriendsViewTableController.friendsSorted[indexPath.section][indexPath.row].nameSurnameUser

        return cell
        }
        else {return UITableViewCell()}
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
        friendsTableController.selectedFriend = FriendsViewTableController.friendsSorted[indexPath.section][indexPath.row]
        }
    
    func loadPhotoFromNet(){
//        for user in friends {
//            MainNetworkService().getAllPhotos(userId: "\(user.serialNumberUser)")
//        }
//            let cub = UIView(); view.addSubview(cub) // создание технической View, которой на экране не видно, но она в рамках следующей анамации будет обеспечивать 3 секундную задержку  для загрузки данных с сети перед переходом в блок Complite, который, в свою очередь, производит переход по Segue на слудующий экран
//
//            UIView.animate(withDuration: 5,
//                           animations: {
//                            cub.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//                           },
//                           completion: { [self] _ in
//                            sortedFriends()
//                            performSegue(withIdentifier: "SeePhoto", sender: indexPath)
//                            cub.removeFromSuperview() // удаление технической View
//                            // удаление облака и всех связанных с ним слоев
//                           })
        for user in friends {
            MainNetworkService().getAllPhotos(userId: "\(user.serialNumberUser)")
        }
        var allPhotoLoad = false
        while !allPhotoLoad {
            allPhotoLoad = true
            for value in friends {
                if value.numberOfImages != value.images.count {
                    allPhotoLoad = false
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        HeightOfSell.middle.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if FriendsViewTableController.friendsSorted[section].count != 0 {
            let header = FriendAndGroupsHeader()
            if let firstChapter = FriendsViewTableController.friendsSorted[section][0].nameSurnameUser.first {
            header.configure(with: String(firstChapter))
            }
            return header
        }
        else {return nil}
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        FriendsViewTableController.friendsSorted = friendsSortedWithoutChoose
        
        var choosedFriends : [[User]] = [[]]
        var workSection = 0
        var lastAddedSection = -1
        
        for (indexOfSection,valueOfSection) in FriendsViewTableController.friendsSorted.enumerated() {
            for row in valueOfSection {
                if row.nameSurnameUser.lowercased().contains(searchText.lowercased()) {
                    if lastAddedSection == -1  {
                        lastAddedSection = indexOfSection
                    }
                    else if lastAddedSection != indexOfSection {
                        choosedFriends.append([])
                        workSection += 1
                        lastAddedSection = indexOfSection
                    }
                    choosedFriends[workSection].append(row)
                }
            }
        }
        FriendsViewTableController.friendsSorted = choosedFriends
        if searchText == "" {
            FriendsViewTableController.friendsSorted = friendsSortedWithoutChoose
        }
        quickTransitionControl.removeFromSuperview()
        quickTransitionSection()
        tableView.reloadData()
    }

    func quickTransitionSection() {
        var nameOfSection = [String]()
        
        
        for section in FriendsViewTableController.friendsSorted {
            if section.count != 0 {
            nameOfSection.append("\(section[0].nameSurnameUser.first!)")
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
