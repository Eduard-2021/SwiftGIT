//
//  AllPhotoOfFriendViewController.swift
//  VK_PlusHW8
//
//  Created by Eduard on 23.04.2021.
//

import UIKit

class AllPhotoOfFriendViewController: UIViewController {
    
    var photosOfSelectedFriend : [Likes]!
    var leftPhoto = UIImageView()
    var centerPhoto = UIImageView()
    var rightPhoto = UIImageView()
    var numberPhoto = 0
    var interactiveAnimator = UIViewPropertyAnimator()
    var factor : CGFloat = 0
    var speedOfMovePhoto : CGFloat = 0
    let pozitionY : CGFloat = 100
    static var destroyPhoto = false
    
    enum DirectionMove {
        case left
        case right
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        leftPhoto.frame = CGRect(x: -self.view.bounds.width, y: pozitionY, width: self.view.bounds.width, height: self.view.bounds.width)
        rightPhoto.frame = CGRect(x: self.view.bounds.width, y: pozitionY, width: self.view.bounds.width, height: self.view.bounds.width)
        centerPhoto.frame = CGRect(x: 0, y: pozitionY, width: self.view.bounds.width, height: self.view.bounds.width)
        
        numberPhoto = FriendInfoCollectionController.numberOfPhoto
        centerPhoto.image = photosOfSelectedFriend[numberPhoto].image
        
        switch (photosOfSelectedFriend.count, numberPhoto) {
            case (2,0) :
                rightPhoto.image = photosOfSelectedFriend[1].image
            case (2,1) :
                leftPhoto.image = photosOfSelectedFriend[0].image
            case (3,1) :
                rightPhoto.image = photosOfSelectedFriend[2].image
                leftPhoto.image = photosOfSelectedFriend[0].image
        default:
            if numberPhoto != photosOfSelectedFriend.count-1 {
            rightPhoto.image = photosOfSelectedFriend[numberPhoto+1].image
            }
            if numberPhoto != 0 {
            leftPhoto.image = photosOfSelectedFriend[numberPhoto-1].image
            }
        }
        
        leftPhoto.isHidden = true
        rightPhoto.isHidden = true
        
        self.view.addSubview(leftPhoto)
        self.view.addSubview(centerPhoto)
        self.view.addSubview(rightPhoto)
        
        centerPhoto.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        centerPhoto.addGestureRecognizer(panGesture)
        
        factor = self.view.bounds.width/100
        
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
//        swipeGesture.direction = [.down, .up]
//        centerPhoto.addGestureRecognizer(swipeGesture)
    }
    
    @objc func didPan(_ sender:UIPanGestureRecognizer) {
        
        let newPosition = sender.translation(in: self.view)
        let changeX = newPosition.x/factor
        
        if abs(newPosition.y) > abs(newPosition.x*2) {
            AllPhotoOfFriendViewController.destroyPhoto = true
            navigationController?.popToRootViewController(animated: true)
//            performSegue(withIdentifier: "closePhotoOfFriend", sender: nil)
            return
        }
        
            switch (sender.state, changeX>0) {
                case (.began, false) :
                  if numberPhoto+1 < photosOfSelectedFriend.count {
                    mainAction(directionMove: .left)
                  }
                      else {
                        animationFirstAndLastPhoto()
                      }
                    
                case (.changed, false) :
                    interactiveAnimator.fractionComplete = -changeX / 100
                case (.ended, false):
                    interactiveAnimator.continueAnimation(
                        withTimingParameters: nil,
                        durationFactor: speedOfMovePhoto)
                case (.began, true) :
                  if  numberPhoto > 0 {
                    mainAction(directionMove: .right)
                  }
                    else {
                        animationFirstAndLastPhoto()
                    }
                    
                case (.changed, true) :
                    interactiveAnimator.fractionComplete = changeX / 100
                case (.ended, true):
                    interactiveAnimator.continueAnimation(
                        withTimingParameters: nil,
                        durationFactor: speedOfMovePhoto)
                default :
                    return
                }
        
    }
    
    
//    @objc func didSwipe(_ sender:UIPanGestureRecognizer) {
        
//        let newPosition = sender.translation(in: self.view)
//        let changeX = newPosition.x/factor
        
//        performSegue(withIdentifier: "closePhotoOfFriend", sender: nil)
        
//            switch sender.state {
//                case (.began, false) :
//                  if numberPhoto+1 < photosOfSelectedFriend.count {
//                    mainAction(directionMove: .left)
//                  }
//                      else {
//                        animationFirstAndLastPhoto()
//                      }
//                    
//                case (.changed, false) :
//                    interactiveAnimator.fractionComplete = -changeX / 100
//                case (.ended, false):
//                    interactiveAnimator.continueAnimation(
//                        withTimingParameters: nil,
//                        durationFactor: speedOfMovePhoto)
//                case (.began, true) :
//                  if  numberPhoto > 0 {
//                    mainAction(directionMove: .right)
//                  }
//                    else {
//                        animationFirstAndLastPhoto()
//                    }
//                    
//                case (.changed, true) :
//                    interactiveAnimator.fractionComplete = changeX / 100
//                case (.ended, true):
//                    interactiveAnimator.continueAnimation(
//                        withTimingParameters: nil,
//                        durationFactor: speedOfMovePhoto)
//                default :
//                    return
//                }
        
//    }
    
    func mainAction(directionMove : DirectionMove) {
        
        var byXCenter : CGFloat
        
        if directionMove == .left {
            rightPhoto.isHidden = false
            byXCenter = -self.view.bounds.width
        }
            else {
                leftPhoto.isHidden = false
                byXCenter = self.view.bounds.width
                
            }
        
        interactiveAnimator = UIViewPropertyAnimator(
            duration: 0.5,
            curve: .easeInOut,
            animations: {
                UIView.animateKeyframes(withDuration: 0.8,
                                    delay: 0,
                                    options: [],
                                    animations: { [self] in
                                        UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                           relativeDuration: 1,
                                                           animations: {
                                                            self.centerPhoto.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
                                                           })
                                        UIView.addKeyframe(withRelativeStartTime: 0.6,
                                                           relativeDuration: 0.4,
                                                           animations: {
                                                            self.centerPhoto.frame = CGRect(x: byXCenter, y: pozitionY+self.view.bounds.width*0.4, width: self.view.bounds.width*0.2, height: self.view.bounds.width*0.2)
                                                           })
                                        UIView.addKeyframe(withRelativeStartTime: 0.6,
                                                           relativeDuration: 0.4,
                                                           animations: {
                                                           if directionMove == .left {
                                                            self.rightPhoto.frame = CGRect(x: 0, y: pozitionY, width: self.view.bounds.width, height: self.view.bounds.width)
                                                           }
                                                               else {
                                                                self.leftPhoto.frame = CGRect(x: 0, y: pozitionY, width: self.view.bounds.width, height: self.view.bounds.width)
                                                               }
                                                           })
                                    },
                                    completion: { [self]_ in
                                        self.centerPhoto.transform = .identity
                                        if directionMove == .left {
                                            self.rightPhoto.transform = .identity
                                            self.rightPhoto.isHidden = true
                                            self.leftPhoto.image = photosOfSelectedFriend[numberPhoto].image
                                            numberPhoto += 1
                                            if numberPhoto+1 < photosOfSelectedFriend.count {
                                                self.rightPhoto.image = photosOfSelectedFriend[numberPhoto+1].image
                                            }
                                        }
                                            else {
                                                self.leftPhoto.transform = .identity
                                                self.leftPhoto.isHidden = true
                                                self.rightPhoto.image = photosOfSelectedFriend[numberPhoto].image
                                                numberPhoto -= 1
                                                if numberPhoto > 0 {
                                                    self.leftPhoto.image = photosOfSelectedFriend[numberPhoto-1].image
                                                }
                                                
                                            }
                                        
                                        self.centerPhoto.image = photosOfSelectedFriend[numberPhoto].image
                                        self.centerPhoto.frame = CGRect(x: 0, y: pozitionY, width: self.view.bounds.width, height: self.view.bounds.width)
                                        self.leftPhoto.frame = CGRect(x: -self.view.bounds.width, y: pozitionY, width: self.view.bounds.width, height: self.view.bounds.width)
                                        self.rightPhoto.frame = CGRect(x: self.view.bounds.width, y: pozitionY, width: self.view.bounds.width, height: self.view.bounds.width)
                                    })
            })
        interactiveAnimator.pauseAnimation()
    }
    
    
    
    func animationFirstAndLastPhoto(){
        interactiveAnimator = UIViewPropertyAnimator(
            duration: 0.5,
            curve: .easeInOut,
            animations: {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 1,
                               options: [],
                               animations: {
                                    self.centerPhoto.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
                               },
                               completion: {_ in
                                UIView.animate(withDuration: 0.5,
                                               delay: 0,
                                               usingSpringWithDamping: 0.3,
                                               initialSpringVelocity: 1,
                                               options: [],
                                               animations: {
                                                    self.centerPhoto.transform = .identity
                                               },
                                               completion: nil)
                               })
                })
        interactiveAnimator.pauseAnimation()
    }
    

}
