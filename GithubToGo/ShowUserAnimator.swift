//
//  UserAvatarAnimator.swift
//  GithubToGo
//
//  Created by Casey R White on 10/25/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class ShowUserAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    // Starting position (i.e. the current position on the fromVC)
    var avatarStartingPosition: CGRect?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Grab references to the two VCs being transitioned between
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserSearchViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserViewController
        
        // Grab a reference to the final position of the image on the toVC
        let avatarFinalPosition = toVC.userAvatarImageView.frame
        // Then update the toVC to set the image in it's starting position
        toVC.userAvatarImageView.frame = self.avatarStartingPosition!
        
        // Add the toVC's view onto the containerView
        let containerView = transitionContext.containerView()
        containerView.addSubview(toVC.view)
        
        // Animate move from starting to final position
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            toVC.userAvatarImageView.frame = avatarFinalPosition
            
        }) { (finished) -> Void in
            
            transitionContext.completeTransition(finished)
        }
    }
}
