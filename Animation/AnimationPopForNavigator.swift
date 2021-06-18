//
//  File.swift
//  VK_PlusHW9
//
//  Created by Eduard on 28.04.2021.
//

import UIKit


class AnimationPopForNavigator : NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationTime : TimeInterval = 1.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else {return}
        
        destination.view.frame = transitionContext.containerView.frame
        transitionContext.containerView.insertSubview(destination.view, belowSubview: source.view)
    
        
        let transition = CGAffineTransform(translationX: source.view.bounds.width, y: 0)
        let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
        let transitionAndScale = scale.concatenating(transition)
        

        UIView.animate(withDuration: animationTime,
                       animations: {
                        source.view.transform = transitionAndScale
                       },
                       completion: {complete in
                        source.view.transform = .identity
                        source.removeFromParent()
                        transitionContext.completeTransition(complete && !transitionContext.transitionWasCancelled)

                       })
    }
    
}

