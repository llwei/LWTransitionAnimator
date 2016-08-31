//
//  LWRippleAnimator.swift
//  LWTransitionAnimator
//
//  Created by 赖灵伟 on 16/7/4.
//  Copyright © 2016年 lailingwei. All rights reserved.
//
//  波纹转场动画

import UIKit

private let kRippleDuration: NSTimeInterval = 0.3
private let kMinRadius: CGFloat = 10.0


class LWRippleAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private weak var transitionContext: UIViewControllerContextTransitioning?
    private var rippleCenter: CGPoint = CGPointZero
    
    init(rippleCenter: CGPoint) {
        super.init()
        self.rippleCenter = rippleCenter
    }
    
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return kRippleDuration
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
        
        self.transitionContext = transitionContext
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        containerView.addSubview(toVC.view)
        
        // Calculate initial radius and finial radius
        rippleCenter = containerView.convertPoint(rippleCenter, toView: toVC.view)
        let initialRect = CGRect(x: rippleCenter.x - kMinRadius,
                                 y: rippleCenter.y - kMinRadius,
                                 width: 2 * kMinRadius,
                                 height: 2 * kMinRadius)
        let minCircleMaskPath = UIBezierPath(ovalInRect: initialRect).CGPath
        let extremeLength = max(CGRectGetHeight(toVC.view.bounds), CGRectGetWidth(toVC.view.bounds))
        let extremeRadius = sqrt(rippleCenter.x * rippleCenter.x + extremeLength * extremeLength)
        let maxCircleMaskPath = UIBezierPath(ovalInRect: CGRectInset(initialRect, -extremeRadius, -extremeRadius)).CGPath
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maxCircleMaskPath
        toVC.view.layer.mask = maskLayer
        
        // Configure ripple animation
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = minCircleMaskPath
        animation.toValue = maxCircleMaskPath
        animation.duration = transitionDuration(transitionContext)
        animation.delegate = self
        maskLayer.addAnimation(animation, forKey: NSStringFromClass(LWRippleAnimator.self))
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        guard let transitionContext = transitionContext else { return }
        transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
    

    
}
