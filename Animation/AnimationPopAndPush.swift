//
//  AnimationPop.swift
//  VK_PlusHW9
//
//  Created by Eduard on 27.04.2021.
//

import UIKit

enum Sing:CGFloat {
    case plus = 1
    case minus = -1
}

class AnimationPop : NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationTime : TimeInterval = 1.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let degree = CGFloat(Double.pi/180)
        
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
        
        destination.view.frame = transitionContext.containerView.frame
        transitionContext.containerView.addSubview(destination.view)
        
        self.changeAnchorPoint(NewX: 1, NewY: 0, DestinationView: destination.view, Sing: .plus)
        
        destination.view.alpha = 0
        
        let rotation = CATransform3DMakeRotation(degree*90, 0, 0, 1)

        destination.view.transform = CATransform3DGetAffineTransform(rotation)

        UIView.animate(withDuration: 1,
                       animations: {
                        destination.view.transform = .identity
                        destination.view.alpha = 1
                       },
                       completion: {complete in
                        transitionContext.completeTransition(complete)
                        
                        self.changeAnchorPoint(NewX: 0.5, NewY: 0.5, DestinationView: destination.view, Sing: .minus)
                        
                       })
    }
    
    func changeAnchorPoint(NewX newX:CGFloat, NewY newY:CGFloat, DestinationView workView: UIView, Sing sing: Sing){
        
        workView.layer.anchorPoint = CGPoint(x: newX, y: newY)
        
        workView.frame = CGRect(x: workView.frame.origin.x + sing.rawValue*workView.bounds.width/2,
                                        y: workView.frame.origin.y - sing.rawValue*workView.bounds.height/2,
                                        width: workView.bounds.width,
                                        height: workView.bounds.height)
    }
    
}


class AnimationPush : NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationTime : TimeInterval = 1.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let degree = CGFloat(Double.pi/180)
        
        guard let destination = transitionContext.viewController(forKey: .to) else {return}
        
        destination.view.frame = transitionContext.containerView.frame
        transitionContext.containerView.addSubview(destination.view)
        
        self.changeAnchorPoint(NewX: 0, NewY: 0, DestinationView: destination.view, Sing: .plus)
        
        destination.view.alpha = 0
        
        let rotation = CATransform3DMakeRotation(degree*270, 0, 0, 1)

        destination.view.transform = CATransform3DGetAffineTransform(rotation)

        UIView.animate(withDuration: 1,
                       animations: {
                        destination.view.transform = .identity
                        destination.view.alpha = 1
                       },
                       completion: {complete in
                        transitionContext.completeTransition(complete)
                        
                        self.changeAnchorPoint(NewX: 0.5, NewY: 0.5, DestinationView: destination.view, Sing: .minus)
                        
                       })
    }
    
    func changeAnchorPoint(NewX newX:CGFloat, NewY newY:CGFloat, DestinationView workView: UIView, Sing sing: Sing){
        
        workView.layer.anchorPoint = CGPoint(x: newX, y: newY)
        
        workView.frame = CGRect(x: workView.frame.origin.x - sing.rawValue*workView.bounds.width/2,
                                        y: workView.frame.origin.y - sing.rawValue*workView.bounds.height/2,
                                        width: workView.bounds.width,
                                        height: workView.bounds.height)
    }
    
}
