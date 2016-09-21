//
//  LWTransitionAnimator.swift
//  LWTransitionAnimator
//
//  Created by 赖灵伟 on 16/7/4.
//  Copyright © 2016年 lailingwei. All rights reserved.
//

import UIKit

class LWTransitionAnimator: NSObject, UINavigationControllerDelegate {

    // MARK: - Properteis
    
    @IBOutlet weak var navigationController: UINavigationController?
    
    fileprivate var interactionController: UIPercentDrivenInteractiveTransition?
    fileprivate lazy var edgePanGesture: UIScreenEdgePanGestureRecognizer = {
        let lazyGesture = UIScreenEdgePanGestureRecognizer(target: self,
                                                           action: #selector(LWTransitionAnimator.backActionForEdgePanGesture(_:)))
        lazyGesture.edges = .left
        return lazyGesture
    }()
    
    
    
    // MARK: - Target actions
    
    func backActionForEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        guard let navigationController = navigationController else {
            return
        }
        
        let progress = sender.translation(in: navigationController.view).x / navigationController.view.bounds.size.width
        
        switch sender.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            navigationController.popViewController(animated: true)
            
        case .changed:
            interactionController?.update(progress)
            
        case .cancelled, .ended, .failed:
            if progress >= 0.5 {
                UIView.animate(withDuration: 0.1,
                                           animations: { 
                                            self.interactionController?.update(1.0)
                    }, completion: { (_) in
                        self.interactionController?.finish()
                        self.interactionController = nil
                })
                
            } else {
                UIView.animate(withDuration: 0.1,
                                           animations: { 
                                            self.interactionController?.update(0.0)
                    }, completion: { (_) in
                        self.interactionController?.cancel()
                        self.interactionController = nil
                })
            }
            
        default:
            break
        }        
    }
    
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                                                              from fromVC: UIViewController,
                                                                                 to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            // TODO: Return .Push type transition animator here
            if toVC is RippleViewController {
                return LWRippleAnimator(rippleCenter: CGPoint(x: fromVC.view.bounds.width, y: 0))
                
            } else if toVC is FlipViewController {
                return LWSystemTransitionAnimator(animationTransition: .flipFromRight)
                
            } else if toVC is CurlViewController {
                return LWSystemTransitionAnimator(animationTransition: .curlUp)
                
            } else if toVC is MagicMoveViewController {
                let vc = fromVC as! ViewController
                return LWMagicMoveAnimator(sourceView: vc.imgButton,
                                           content:vc.imgButton.currentBackgroundImage!,
                                           targetFrame: CGRect(x: 0, y: 65, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64),
                                           contentMode: .scaleAspectFit)
            }
            return nil
            
        case .pop:
            // TODO: Return .Pop type transition animator here
            if fromVC is RippleViewController {
                return LWRippleAnimator(rippleCenter: CGPoint.zero)
                
            } else if fromVC is FlipViewController {
                return LWSystemTransitionAnimator(animationTransition: .flipFromLeft)
                
            } else if fromVC is CurlViewController {
                return LWSystemTransitionAnimator(animationTransition: .curlDown)
                
            } else if fromVC is MagicMoveViewController {
                let from = fromVC as! MagicMoveViewController
                let to = toVC as! ViewController
                return LWMagicMoveAnimator(sourceView: from.imgView,
                                           content:from.imgView.image!,
                                           targetFrame: to.imgButton.frame,
                                           contentMode: .scaleAspectFit)
            }
            return nil
        default:
            return nil
        }
    }

    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                                                    animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            navigationController.view.removeGestureRecognizer(edgePanGesture)
        } else {
            navigationController.view.addGestureRecognizer(edgePanGesture)
        }
    }
    
}
