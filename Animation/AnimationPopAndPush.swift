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

let degree = CGFloat(Double.pi/180) //перевод радиан в градусы
let animationTime : TimeInterval = 1.5


class AnimationPop : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animation(transitionContext: transitionContext, newX: 1, angle: 90, singDirection: 1)
    }
}

class AnimationPush : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animation(transitionContext: transitionContext, newX: 0, angle: 270, singDirection: -1)
    }
}

func animation(transitionContext:UIViewControllerContextTransitioning, newX : CGFloat, angle: CGFloat, singDirection : CGFloat){
    guard
        let destination = transitionContext.viewController(forKey: .to) else {return}

    destination.view.frame = transitionContext.containerView.frame
    transitionContext.containerView.addSubview(destination.view)

    //Вызов метода, который изменят точку вращения экрана (на верхнюю правую или левую в зависимости от направления перехода - назад или вперед) при анимации возврата на предыдущее окно, при этом размер  View исчисляется в относительных значениях от 0 до 1
    changeAnchorPoint(NewX: newX, NewY: 0, DestinationView: destination.view, Sing: .plus, singDirection: singDirection)

    destination.view.alpha = 0

    // 3D анимация вращения вокруг z координаты (сначала производиться соответствующая трансформация
    let rotation = CATransform3DMakeRotation(degree*angle, 0, 0, 1)
    destination.view.transform = CATransform3DGetAffineTransform(rotation)

    UIView.animate(withDuration: 1,
                   animations: {
                    destination.view.transform = .identity
                    destination.view.alpha = 1
                   },
                   completion: {complete in
                    transitionContext.completeTransition(complete)

                    //Вызов метода, который возвращает точку вращения экрана в его центр
                    changeAnchorPoint(NewX: 0.5, NewY: 0.5, DestinationView: destination.view, Sing: .minus, singDirection: singDirection)
                   })

}

func changeAnchorPoint(NewX newX:CGFloat, NewY newY:CGFloat, DestinationView workView: UIView, Sing sing: Sing, singDirection : CGFloat) {
    
    workView.layer.anchorPoint = CGPoint(x: newX, y: newY)
    
    workView.frame = CGRect(x: workView.frame.origin.x + singDirection*sing.rawValue*workView.bounds.width/2,
                                    y: workView.frame.origin.y - sing.rawValue*workView.bounds.height/2,
                                    width: workView.bounds.width,
                                    height: workView.bounds.height)
}





