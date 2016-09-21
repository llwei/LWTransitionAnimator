//
//  LWRippleAnimator.swift
//  LWTransitionAnimator
//
//  Created by 赖灵伟 on 16/7/4.
//  Copyright © 2016年 lailingwei. All rights reserved.
//
//  波纹转场动画

import UIKit

private let kRippleDuration: TimeInterval = 0.3
private let kMinRadius: CGFloat = 10.0


class LWRippleAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {

    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    fileprivate var rippleCenter: CGPoint = CGPoint.zero
    
    init(rippleCenter: CGPoint) {
        super.init()
        self.rippleCenter = rippleCenter
    }
    
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kRippleDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            print("ToVC is nil")
            return
        }
        let containerView = transitionContext.containerView
        self.transitionContext = transitionContext
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        containerView.addSubview(toVC.view)
        
        // Calculate initial radius and finial radius
        rippleCenter = containerView.convert(rippleCenter, to: toVC.view)
        let initialRect = CGRect(x: rippleCenter.x - kMinRadius,
                                 y: rippleCenter.y - kMinRadius,
                                 width: 2 * kMinRadius,
                                 height: 2 * kMinRadius)
        let minCircleMaskPath = UIBezierPath(ovalIn: initialRect).cgPath
        let extremeLength = max(toVC.view.bounds.height, toVC.view.bounds.width)
        let extremeRadius = sqrt(rippleCenter.x * rippleCenter.x + extremeLength * extremeLength)
        let maxCircleMaskPath = UIBezierPath(ovalIn: initialRect.insetBy(dx: -extremeRadius, dy: -extremeRadius)).cgPath
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maxCircleMaskPath
        toVC.view.layer.mask = maskLayer
        
        // Configure ripple animation
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = minCircleMaskPath
        animation.toValue = maxCircleMaskPath
        animation.duration = transitionDuration(using: transitionContext)
        animation.delegate = self
        maskLayer.add(animation, forKey: NSStringFromClass(LWRippleAnimator.self))
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let transitionContext = transitionContext else { return }
        transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    

    
}
