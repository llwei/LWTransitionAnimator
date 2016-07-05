//
//  LWMagicMoveAnimator.swift
//  LWTransitionAnimator
//
//  Created by 赖灵伟 on 16/7/5.
//  Copyright © 2016年 lailingwei. All rights reserved.
//
//  神奇移动转场动画

import UIKit

private let kMagicMoveDuration: NSTimeInterval = 0.35

class LWMagicMoveAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var sourceView: UIView!
    private var content: UIImage!
    private var targetFrame: CGRect!
    private var contentMode = UIViewContentMode.ScaleAspectFit
    
    init(sourceView: UIView, content: UIImage, targetFrame: CGRect, contentMode: UIViewContentMode) {
        super.init()
        self.sourceView = sourceView
        self.content = content
        self.targetFrame = targetFrame
        self.contentMode = contentMode
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return kMagicMoveDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
            print("ToVC is nil")
            return
        }
        guard let container = transitionContext.containerView() else {
            print("Container is nil")
            return
        }

        // Create a snaphot view to replace source view
        let snapshot = UIImageView(image: content)
        snapshot.contentMode = contentMode
        snapshot.frame = container.convertRect(sourceView.frame, fromView: sourceView.superview)
        sourceView.hidden = true
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.view.alpha = 0.0
        container.addSubview(toVC.view)
        container.addSubview(snapshot)
        
        // Animate
        UIView.animateWithDuration(transitionDuration(transitionContext),
                                   delay: 0.0,
                                   options: .CurveEaseOut,
                                   animations: { 
                                    snapshot.frame = self.targetFrame
                                    toVC.view.alpha = 1.0
            }) { (_) in
                self.sourceView.hidden = false
                snapshot.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }

}

