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
    }
}
    
