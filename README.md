# LWTransitionAnimator
自定义转场动画

Deployment Target 7.0

介绍：目前仅提供了“波纹扩散”、“左右翻转”、“上下翻页”、“神奇移动”几个转场动画。

一、使用方法：
    
    1、初始化LWTransitionAnimator，转场动画管理器

    代码方法：

    class NavigationController: UINavigationController {

        let transitionAnimator = LWTransitionAnimator()

        override func viewDidLoad() {
            super.viewDidLoad()
            transitionAnimator.navigationController = self
            delegate = transitionAnimator
        }
    }

    或者用storyboard方法：

    a、把 NSObject 控件拖入UINavigationController，让改NSObject继承 LWTransitionAnimator。
    b、让导航栏的delegate指向 LWTransitionAnimator。
    c、让 LWTransitionAnimator 的navigationController 指向改导航栏。


    2、在 LWTransitionAnimator 对象中，navigationController(_:animationControllerForOperation:fromViewController:toViewController:)方法里返回需要的转场动画。

    func navigationController(navigationController: UINavigationController,
                              animationControllerForOperation operation: UINavigationControllerOperation,
                                                              fromViewController fromVC: UIViewController,
                                                                                 toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .Push:
            // TODO: Return .Push type transition animator here
            if toVC is RippleViewController {
                return LWRippleAnimator(rippleCenter: CGPoint(x: fromVC.view.bounds.width, y: 0))

            } else if toVC is FlipViewController {
                return LWSystemTransitionAnimator(animationTransition: .FlipFromRight)

            } else if toVC is CurlViewController {
                return LWSystemTransitionAnimator(animationTransition: .CurlUp)

            } else if toVC is MagicMoveViewController {
                let vc = fromVC as! ViewController
                return LWMagicMoveAnimator(sourceView: vc.imgButton,
                                           content:vc.imgButton.currentBackgroundImage!,
                                           targetFrame: CGRect(x: 0, y: 65, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height - 64),
                                           contentMode: .ScaleAspectFit)
            }
            return nil

        case .Pop:
            // TODO: Return .Pop type transition animator here
            if fromVC is RippleViewController {
                return LWRippleAnimator(rippleCenter: CGPointZero)

            } else if fromVC is FlipViewController {
                return LWSystemTransitionAnimator(animationTransition: .FlipFromLeft)

            } else if fromVC is CurlViewController {
                return LWSystemTransitionAnimator(animationTransition: .CurlDown)

            } else if fromVC is MagicMoveViewController {
                let from = fromVC as! MagicMoveViewController
                let to = toVC as! ViewController
                return LWMagicMoveAnimator(sourceView: from.imgView,
                                           content:from.imgView.image!,
                                           targetFrame: to.imgButton.frame,
                                           contentMode: .ScaleAspectFit)
            }
            return nil
        default:
            return nil
        }
    }
