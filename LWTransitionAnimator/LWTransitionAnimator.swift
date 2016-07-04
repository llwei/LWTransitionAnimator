//
//  LWTransitionAnimator.swift
//  LWTransitionAnimator
//
//  Created by 赖灵伟 on 16/7/4.
//  Copyright © 2016年 lailingwei. All rights reserved.
//

import UIKit

private let kAnimateDuration: NSTimeInterval = 0.25

class LWTransitionAnimator: NSObject, UINavigationControllerDelegate {

    // MARK: - Properteis
    
    @IBOutlet weak var navigationController: UINavigationController?
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private lazy var edgePanGesture: UIScreenEdgePanGestureRecognizer = {
        let lazyGesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                           action: #selector(LWTransitionAnimator.backActionForEdgePanGesture(_:)))
        lazyGesture.edges = .Left
        return lazyGesture
    }()
    
    
    
    // MARK: - Target actions
    
    func backActionForEdgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        guard let navigationController = navigationController else {
            return
        }
        
        let progress = sender.translationInView(navigationController.view).x / navigationController.view.bounds.size.width
        
        switch sender.state {
        case .Began:
            interactionController = UIPercentDrivenInteractiveTransition()
            navigationController.popViewControllerAnimated(true)
            
        case .Changed:
            interactionController?.updateInteractiveTransition(progress)
            
        case .Cancelled, .Ended, .Failed:
            if progress >= 0.5 {
                UIView.animateWithDuration(kAnimateDuration,
                                           delay: 0,
                                           options: .CurveEaseOut,
                                           animations: { 
                                                self.interactionController?.updateInteractiveTransition(1.0)
                    }, completion: { (_) in
                        self.interactionController?.finishInteractiveTransition()
                        self.interactionController = nil
                })
                
            } else {
                UIView.animateWithDuration(kAnimateDuration,
                                           delay: 0,
                                           options: .CurveEaseOut,
                                           animations: {
                                            self.interactionController?.updateInteractiveTransition(0.0)
                    }, completion: { (_) in
                        self.interactionController?.cancelInteractiveTransition()
                        self.interactionController = nil
                })
            }
            
        default:
            break
        }        
    }
    
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController,
                              animationControllerForOperation operation: UINavigationControllerOperation,
                                                              fromViewController fromVC: UIViewController,
                                                                                 toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .Push:
            // TODO: Return .Push type transition animator here
            if fromVC is ViewController {
//                return LWRippleAnimator(rippleCenter: CGPoint(x: fromVC.view.bounds.width, y: 0))
                return LWSystemTransitionAnimator(animationTransition: .CurlUp)
            }
            return nil
        case .Pop:
            // TODO: Return .Pop type transition animator here
            if toVC is ViewController {
//                return LWRippleAnimator(rippleCenter: CGPointZero)
                return LWSystemTransitionAnimator(animationTransition: .CurlDown)
            }
            return nil
        default:
            return nil
        }
    }

    
    func navigationController(navigationController: UINavigationController,
                              interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    
    func navigationController(navigationController: UINavigationController,
                              didShowViewController viewController: UIViewController,
                                                    animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            navigationController.view.removeGestureRecognizer(edgePanGesture)
        } else {
            navigationController.view.addGestureRecognizer(edgePanGesture)
        }
    }
    
}
