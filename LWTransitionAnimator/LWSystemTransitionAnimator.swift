//
//  LWSystemTransitionAnimator.swift
//  LWTransitionAnimator
//
//  Created by 赖灵伟 on 16/7/5.
//  Copyright © 2016年 lailingwei. All rights reserved.
//
//  系统提供的4个转场动画

import UIKit

private let kSystemTransitionDuration: NSTimeInterval = 0.5

class LWSystemTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private var transition: UIViewAnimationTransition
    
    
    init(animationTransition: UIViewAnimationTransition) {
        transition = animationTransition
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return kSystemTransitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
            print("ToVC is nil")
            return
        }
        guard let containerView = transitionContext.containerView() else {
            print("ContainerView is nil")
            return
        }
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        containerView.addSubview(toVC.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            UIView.setAnimationTransition(self.transition, forView: containerView, cache: true)
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
}
