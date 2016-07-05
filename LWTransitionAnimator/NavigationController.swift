//
//  NavigationController.swift
//  LWTransitionAnimator
//
//  Created by 赖灵伟 on 16/7/4.
//  Copyright © 2016年 lailingwei. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    let transitionAnimator = LWTransitionAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitionAnimator.navigationController = self
        delegate = transitionAnimator
    }
}
