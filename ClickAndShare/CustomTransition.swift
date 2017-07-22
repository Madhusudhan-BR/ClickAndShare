//
//  CustomTransition.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/21/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // custom transition logic 
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        containerView.addSubview(toView)
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        toView.frame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
        
        
        
        
    }
}
    
