//
//  File.swift
//  VK_PlusHW9
//
//  Created by Eduard on 30.04.2021.
//

import UIKit

    class AnimationCreateBigPhoto: NSObject, UIViewControllerAnimatedTransitioning {
        
        let animationTime : TimeInterval = 1.5
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            animationTime
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

            guard let source = transitionContext.viewController(forKey: .from),
                  let destination = transitionContext.viewController(forKey: .to)
            else {return}

            transitionContext.containerView.addSubview(destination.view)

            destination.view.alpha = 0

        guard let bigPhotoViewController = destination as? AllPhotoOfFriendViewController
        else {return}

        let newPozitionPhoto = bigPhotoViewController.centerPhoto.frame.origin
        let widthNewPhoto = bigPhotoViewController.centerPhoto.bounds.width
        let heightNewPhoto = bigPhotoViewController.centerPhoto.bounds.height
            
        bigPhotoViewController.centerPhoto.isHidden = true
        let photoForAnimation = UIImageView(image: bigPhotoViewController.centerPhoto.image)

        let oldPozitionPhoto = FriendInfoCollectionController.pozitionCellForAnimation

        photoForAnimation.frame = CGRect(
            x: oldPozitionPhoto!.x+10,
            y: oldPozitionPhoto!.y+10,
            width: 180,
            height: 180)

        transitionContext.containerView.addSubview(photoForAnimation)

        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
                        photoForAnimation.frame = CGRect(x: newPozitionPhoto.x, y: newPozitionPhoto.y, width: widthNewPhoto, height: heightNewPhoto)
                        destination.view.alpha = 1
                        source.view.alpha = 0
                       },
                       completion: {complete in
                        bigPhotoViewController.centerPhoto.isHidden = false
                        source.view.alpha = 1
                        photoForAnimation.removeFromSuperview()
                        transitionContext.completeTransition(complete && !transitionContext.transitionWasCancelled)
                       })
    }
        
}


class AnimationDestroyBigPhoto: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationTime : TimeInterval = 1.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationTime
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        AllPhotoOfFriendViewController.destroyPhoto = false

        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to)
        else {return}

        transitionContext.containerView.addSubview(destination.view)

        destination.view.alpha = 0

    guard let bigPhotoViewController = source as? AllPhotoOfFriendViewController
    else {return}

        
    let widthNewPhoto = bigPhotoViewController.centerPhoto.bounds.width/10
    let heightNewPhoto = bigPhotoViewController.centerPhoto.bounds.height/10
        let newPozitionPhoto = CGPoint(x: bigPhotoViewController.centerPhoto.bounds.width/2 - widthNewPhoto, y: -bigPhotoViewController.centerPhoto.bounds.height/10)
        
    UIView.animate(withDuration: 1,
                   delay: 0,
                   options: [],
                   animations: {
                   bigPhotoViewController.centerPhoto.frame = CGRect(x: newPozitionPhoto.x, y: newPozitionPhoto.y, width: widthNewPhoto, height: heightNewPhoto)
                    
                    destination.view.alpha = 1
                    source.view.alpha = 0
                   },
                   completion: {complete in
                    source.view.alpha = 1
                    transitionContext.completeTransition(complete && !transitionContext.transitionWasCancelled)
                   })
    }
    
}
