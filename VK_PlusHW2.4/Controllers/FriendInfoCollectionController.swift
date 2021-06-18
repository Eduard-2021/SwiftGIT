
import UIKit


class FriendInfoCollectionController: UICollectionViewController {
    
    static var numberOfPhoto = 0
    static var pozitionCellForAnimation: CGPoint!
    static var photoCellForAnimation : UIImage!
    let animationThroughNavigation = AnimationCreateBigPhoto()
    
    var selectedFriend : User!
    

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let window = UIApplication.shared.keyWindow,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCollectionViewCell", for: indexPath) as? FotoCollectionViewCell
        else {return}
      
        FriendInfoCollectionController.pozitionCellForAnimation = collectionView.convert(cell.frame.origin, to: window)
       
        FriendInfoCollectionController.numberOfPhoto = indexPath.row
        
        performSegue(withIdentifier: "ShowBigPhoto", sender: indexPath)
       

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "ShowBigPhoto",
            let bigPhotoViewController = segue.destination as? AllPhotoOfFriendViewController
            else {return}
            bigPhotoViewController.photosOfSelectedFriend = selectedFriend.images
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let ss = selectedFriend else {return 1}
        return ss.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCollectionViewCell", for: indexPath) as! FotoCollectionViewCell
        if let ss = selectedFriend {
            cell.FotoOfFriend.image = ss.images[indexPath.row].image
            cell.numberLikes.text = String(ss.images[indexPath.row].numLikes)
            if ss.images[indexPath.row].i_like {
                cell.buttonLikeColor.setImage(UIImage(named: "Like")!, for: .normal)
            }
                else {
                    cell.buttonLikeColor.setImage(UIImage(named: "NoLike")!, for: .normal)
                }
            cell.serNumberUser.text = String(ss.serialNumberUser)
            cell.serNumberPhoto.text = String(ss.images[indexPath.row].serialNumberPhoto)
        }
        else {}
        
        return cell
        
    }
    
    override func viewDidLoad() {
        let cellName = UINib(nibName: "FotoCollectionViewCell", bundle: nil)
        collectionView.register(cellName, forCellWithReuseIdentifier: "FotoCollectionViewCell")
//        MainNetworkService().getAllPhotos(ownerId:"\(DataAboutSession.data.userID)")
        MainNetworkService().getAllPhotos(userId:"604130258")
        
    }
    
}

extension FriendInfoCollectionController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationThroughNavigation
    }
}
