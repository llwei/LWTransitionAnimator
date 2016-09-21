//
//  LWMagicMoveAnimator.swift
//  LWTransitionAnimator
//
//  Created by 赖灵伟 on 16/7/5.
//  Copyright © 2016年 lailingwei. All rights reserved.
//
//  神奇移动转场动画

import UIKit

private let kMagicMoveDuration: TimeInterval = 0.35

class LWMagicMoveAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate var sourceView: UIView!
    fileprivate var content: UIImage!
    fileprivate var targetFrame: CGRect!
    fileprivate var contentMode = UIViewContentMode.scaleAspectFit
    
    init(sourceView: UIView, content: UIImage, targetFrame: CGRect, contentMode: UIViewContentMode) {
        super.init()
        self.sourceView = sourceView
        self.content = content
        self.targetFrame = targetFrame
        self.contentMode = contentMode
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kMagicMoveDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            print("ToVC is nil")
            return
        }
        let container = transitionContext.containerView

        // Create a snaphot view to replace source view
        let snapshot = UIImageView(image: content)
        snapshot.contentMode = contentMode
        snapshot.frame = container.convert(sourceView.frame, from: sourceView.superview)
        sourceView.isHidden = true
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0.0
        container.addSubview(toVC.view)
        container.addSubview(snapshot)
        
        // Animate
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                                   delay: 0.0,
                                   options: .curveEaseOut,
                                   animations: { 
                                    snapshot.frame = self.targetFrame
                                    toVC.view.alpha = 1.0
            }) { (_) in
                self.sourceView.isHidden = false
                snapshot.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

}

