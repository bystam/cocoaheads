//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

final class CuteNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        transitionNavigationBar(between: nil, and: topViewController, isPush: true, animated: false)
    }

    override var tabBarTheme: CuteTabBarTheme {
        return topViewController?.tabBarTheme ?? .light
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let previous = viewControllers.last
        super.pushViewController(viewController, animated: animated)
        performTransition(between: previous, and: viewController, isPush: true, animated: animated)
    }

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        let previous = self.viewControllers.last
        super.setViewControllers(viewControllers, animated: animated)
        performTransition(between: previous, and: viewControllers.last, isPush: true, animated: animated)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let popped = super.popViewController(animated: animated)
        performTransition(between: popped, and: viewControllers.last, isPush: false, animated: animated)
        return popped
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let popped = super.popToViewController(viewController, animated: animated)
        performTransition(between: popped?.last, and: viewController, isPush: false, animated: animated)
        return popped
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let popped = super.popToRootViewController(animated: animated)
        performTransition(between: popped?.last, and: viewControllers.last, isPush: false, animated: animated)
        return popped
    }

    private func performTransition(between current: UIViewController?, and next: UIViewController?, isPush: Bool, animated: Bool) {
        transitionNavigationBar(between: current, and: next, isPush: isPush, animated: animated)
        transitionTabBar(between: current, and: next, isPush: isPush, animated: animated)
    }

    private func transitionNavigationBar(between current: UIViewController?, and next: UIViewController?, isPush: Bool, animated: Bool) {
        guard let navbar = navigationBar as? CuteNavigationBar else {
            return
        }

        let isTransparent = current?.prefersNavigationBarTransparent == true
        let willBeTransparent = next?.prefersNavigationBarTransparent == true

        guard isTransparent != willBeTransparent else {
            return
        }

        if let coordinator = transitionCoordinator, animated {
            let currentOffset = navbar.backgroundOffset
            if isTransparent {
                navbar.backgroundOffset = isPush ? .right : .left
                navbar.layoutIfNeeded()
            }

            coordinator.animate(alongsideTransition: { context in
                navbar.backgroundOffset = willBeTransparent ? (isPush ? .left : .right) : .none
                navbar.layoutIfNeeded()
            }, completion: { context in
                if context.isCancelled {
                    navbar.backgroundOffset = currentOffset
                }
            })

        } else {
            navbar.backgroundOffset = willBeTransparent ? .left : .none
        }
    }

    private func transitionTabBar(between current: UIViewController?, and next: UIViewController?, isPush: Bool, animated: Bool) {
        guard let tabController = tabBarController as? CuteTabBarController else {
            return
        }

        let oldTheme = current?.tabBarTheme ?? .light
        let newTheme = next?.tabBarTheme ?? .light

        guard oldTheme !== newTheme else {
            return
        }

        if let coordinator = transitionCoordinator, animated {

            tabController.prepareForTabBarNavigationTransition(from: isPush ? .right : .left)
            tabController.configureTabBar(with: newTheme)

            coordinator.animate(alongsideTransition: { context in
                tabController.animateNavigationTransition(to: isPush ? .left : .right)
            }, completion: { context in
                if context.isCancelled {
                    tabController.configureTabBar(with: oldTheme)
                }
                tabController.cleanUpNavigationTransition()
            })

        } else {
            tabController.configureTabBar(with: newTheme)
        }
    }
}

extension UIViewController {

    @objc(cute_prefersNavigationBarTransparent)
    var prefersNavigationBarTransparent: Bool {
        return false
    }
}

final class CuteNavigationBar: UINavigationBar {

    enum BackgroundOffset {
        case none, left, right
    }

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkPurple
        return view
    }()

    var backgroundOffset: BackgroundOffset = .none {
        didSet {
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addSubview(backgroundView)
        isTranslucent = true
        tintColor = .white
        shadowImage = UIImage()
        barStyle = .black
        setBackgroundImage(UIImage(), for: .default)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        sendSubviewToBack(backgroundView)

        let rect = CGRect(x: 0, y: -44, width: bounds.width, height: 88)
        switch backgroundOffset {
        case .none:
            backgroundView.frame = rect
        case .left:
            backgroundView.frame = rect.offsetBy(dx: -bounds.width, dy: 0)
        case .right:
            backgroundView.frame = rect.offsetBy(dx: bounds.width, dy: 0)
        }
    }
}
