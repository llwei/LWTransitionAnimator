//
//  LWSystemTransitionAnimator.swift
//  LWTransitionAnimator
//
//  Created by 赖灵伟 on 16/7/5.
//  Copyright © 2016年 lailingwei. All rights reserved.
//
//  系统提供的4个转场动画

import UIKit

private let kSystemTransitionDuration: TimeInterval = 0.45

class LWSystemTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    fileprivate var transition: UIViewAnimationTransition
    
    
    init(animationTransition: UIViewAnimationTransition) {
        transition = animationTransition
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kSystemTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            print("ToVC is nil")
            return
        }
        let containerView = transitionContext.containerView
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            UIView.setAnimationTransition(self.transition, for: containerView, cache: true)
        }, completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }) 
    }
    
}
