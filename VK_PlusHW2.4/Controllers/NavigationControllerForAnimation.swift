//
//  File.swift
//  VK_PlusHW9
//
//  Created by Eduard on 28.04.2021.
//

import UIKit

class InteractiveTransitionForAnimation : UIPercentDrivenInteractiveTransition {
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
}

class NavigationControllerForAnimation : UINavigationController, UINavigationControllerDelegate {
    
    let interactiveTransitionForAnimation = InteractiveTransitionForAnimation()
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        switch operation {
        case .pop:
            if FriendInfoCollectionController.pozitionCellForAnimation != nil {
                FriendInfoCollectionController.pozitionCellForAnimation = nil
            }
            if interactiveTransitionForAnimation.hasStarted {
            return AnimationPopForNavigator()
            } else {
                return !AllPhotoOfFriendViewController.destroyPhoto ? AnimationPop() : AnimationDestroyBigPhoto()
        }
        case .push:
            if FriendInfoCollectionController.pozitionCellForAnimation == nil {
                return AnimationPush()
            }
            else {
                return AnimationCreateBigPhoto()
            }
        default:
            return AnimationPop()
        }
    }
    
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
       return interactiveTransitionForAnimation.hasStarted ? interactiveTransitionForAnimation : nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let screenGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenGS(_:)))
        screenGesture.edges = .left
        view.addGestureRecognizer(screenGesture)

    }
    
    @objc func screenGS(_ recognizer : UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began :
            interactiveTransitionForAnimation.hasStarted = true
            popViewController(animated: true)

        case .changed:
            guard let width = recognizer.view?.bounds.width else {
                interactiveTransitionForAnimation.hasStarted = false
                interactiveTransitionForAnimation.cancel()
                return
            }
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x/width
            let progress = max(0, min(relativeTranslation,1))
            interactiveTransitionForAnimation.update(progress)
            interactiveTransitionForAnimation.shouldFinish = progress > 0.35
        case .ended:
            interactiveTransitionForAnimation.hasStarted = false
            if interactiveTransitionForAnimation.shouldFinish {
                interactiveTransitionForAnimation.finish()
            }
            else {
                interactiveTransitionForAnimation.cancel()
            }
        case .cancelled:
            interactiveTransitionForAnimation.hasStarted = false
            interactiveTransitionForAnimation.cancel()
        case .failed:
            interactiveTransitionForAnimation.hasStarted = false
            interactiveTransitionForAnimation.cancel()
       default: return

        }
    }
}
