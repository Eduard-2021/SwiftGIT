
import UIKit
import RealmSwift
import Kingfisher


class FriendInfoCollectionController: UICollectionViewController {
    
    
    static var numberOfPhoto = 0
    static var pozitionCellForAnimation: CGPoint!
    static var photoCellForAnimation : UIImage!
    let animationThroughNavigation = AnimationCreateBigPhoto()
    
    private let networkService = MainNetworkService()
    var users = try? RealmService.load(typeOf: RealmUser.self, sortedKey: "fullName")
    var realmUserPhotos = try? RealmService.load(typeOf: RealmUserPhoto.self, sortedKey: "serialNumberPhoto")
    var token: NotificationToken?
    
    var selectedFriend : User!
    
    var selectedUser : Int!
    

    private func updateCollectioViewFromRealm() {
        guard let realmUserPhotos = self.realmUserPhotos else {return}
        
        self.token = realmUserPhotos.observe { [self]  (changes: RealmCollectionChange) in
                    switch changes {
                    case .initial:
                                    self.collectionView.reloadData()
                    case .update(_, let deletions, let insertions, let modifications):
                       
                                    self.collectionView.reloadData()
                    case .error(let error):
                        print(error)
                    }
                }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let window = UIApplication.shared.keyWindow,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCollectionViewCell", for: indexPath) as? FotoCollectionViewCell
        else {return}
        
        cell.FotoOfFriend.isHidden = true
        collectionView.reloadData()
        
        FriendInfoCollectionController.pozitionCellForAnimation = collectionView.convert(cell.frame.origin, to: window)
        FriendInfoCollectionController.numberOfPhoto = indexPath.row
        
        performSegue(withIdentifier: "ShowBigPhoto", sender: indexPath)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "ShowBigPhoto",
            let bigPhotoViewController = segue.destination as? AllPhotoOfFriendViewController
            else {return}
        
            bigPhotoViewController.selectedUser = selectedUser
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let ss = selectedUser else {return 1}
        let allPhotoOfUsers = realmUserPhotos!.filter("idUser == %@", ss)
        return allPhotoOfUsers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCollectionViewCell", for: indexPath) as! FotoCollectionViewCell
        guard let ss = selectedUser else {return UICollectionViewCell()}
        let allPhotoOfUsers = realmUserPhotos!.filter("idUser == %@", ss)

        cell.configure(imageURL: allPhotoOfUsers[indexPath.row].URLimage, numLikes: allPhotoOfUsers[indexPath.row].numLikes, i_like: allPhotoOfUsers[indexPath.row].i_like, id: allPhotoOfUsers[indexPath.row].idUser, serialNumberPhoto: allPhotoOfUsers[indexPath.row].serialNumberPhoto)
        
        return cell
        
    }
    
    override func viewDidLoad() {
        let cellName = UINib(nibName: "FotoCollectionViewCell", bundle: nil)
        collectionView.register(cellName, forCellWithReuseIdentifier: "FotoCollectionViewCell")
        loadPhotoFromRealm()
        updateCollectioViewFromRealm()
        
    }
    
    private func loadPhotoFromRealm() {
        for value in users! {
            networkService.getAllPhotos(userId: String(value.id)) {[weak self] vkFriendsPhoto in
                guard
                    let vkPhotos = vkFriendsPhoto
                else { return }
                var vkPhotosWithNumber = [RealmUserPhoto]()
                for (index,value) in vkPhotos.enumerated() {
                    vkPhotosWithNumber.append(value)
                    vkPhotosWithNumber[index].serialNumberPhoto = index
                }
                try? RealmService.save(items: vkPhotosWithNumber)
            }
        }
    }
    
}

extension FriendInfoCollectionController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationThroughNavigation
    }
}
