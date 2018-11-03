//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

final class CuteTabBarTheme: NSObject {
    let selectedColor: UIColor
    let deselectedColor: UIColor
    let backgroundColor: UIColor
    let hasShadow: Bool

    private init(selectedColor: UIColor, deselectedColor: UIColor, backgroundColor: UIColor, hasShadow: Bool) {
        self.selectedColor = selectedColor
        self.deselectedColor = deselectedColor
        self.backgroundColor = backgroundColor
        self.hasShadow = hasShadow
    }

    static let light: CuteTabBarTheme = .init(selectedColor: .darkPurple,
                                              deselectedColor: .lightGray,
                                              backgroundColor: UIColor(red: (253.0 / 255),
                                                                       green: (248.0 / 255),
                                                                       blue: (255.0 / 255),
                                                                       alpha: 1.0),
                                              hasShadow: true)
    static let transparent: CuteTabBarTheme = .init(selectedColor: .white,
                                                    deselectedColor: .lightGray,
                                                    backgroundColor: .clear,
                                                    hasShadow: false)
    static let dark: CuteTabBarTheme = .init(selectedColor: .white,
                                             deselectedColor: .lightGray,
                                             backgroundColor: UIColor(white: 0.1, alpha: 1.0),
                                             hasShadow: false)
}


final class CuteTabBarController: UITabBarController {

    enum TabBarTransitionDirection {
        case left, right
    }

    private let barShadowView: UIView = {
        let view = UIView()
        view.autoresizingMask = [.flexibleBottomMargin]
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        return view
    }()

    private var barSnapshot: UIView?

    override var selectedIndex: Int {
        didSet {
            reloadTabBarStyle()
        }
    }

    override var selectedViewController: UIViewController? {
        didSet {
            reloadTabBarStyle()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.addSubview(barShadowView)
        barShadowView.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: 1.0)
    }

    func configureTabBar(with theme: CuteTabBarTheme) {
        tabBar.tintColor = theme.selectedColor
        tabBar.isTranslucent = theme.backgroundColor.isClear
        tabBar.barTintColor = theme.backgroundColor
        barShadowView.isHidden = !theme.hasShadow

        viewControllers?
            .compactMap { $0.tabBarItem }
            .forEach { paint($0, with: theme) }

        if let snapshot = barSnapshot {
            tabBar.bringSubviewToFront(snapshot)
        }
    }

    private func reloadTabBarStyle() {
        guard let theme = selectedViewController?.tabBarTheme else {
            return
        }
        configureTabBar(with: theme)
    }

    private func paint(_ item: UITabBarItem, with theme: CuteTabBarTheme) {
        item.selectedImage = item.selectedImage?.tinted(with: theme.selectedColor)
        item.image = item.image?.tinted(with: theme.deselectedColor)
    }

    // MARK: - Cute transition

    func prepareForTabBarNavigationTransition(from direction: TabBarTransitionDirection) {
        guard let snapshot = tabBar.snapshotView(afterScreenUpdates: false) else {
            return
        }
        snapshot.frame = tabBar.frame
        snapshot.isUserInteractionEnabled = false

        if tabBar.barTintColor?.isClear == true {
            tabBar.mask = UIView()
            tabBar.mask?.backgroundColor = .white
            tabBar.mask?.frame = snapshot.bounds
            view.insertSubview(snapshot, belowSubview: tabBar)

            let width = tabBar.bounds.width
            switch direction {
            case .left:
                tabBar.mask?.transform = CGAffineTransform(translationX: -width, y: 0)
            case .right:
                tabBar.mask?.transform = CGAffineTransform(translationX: width, y: 0)
            }

        } else {
            snapshot.mask = UIView()
            snapshot.mask?.backgroundColor = .white
            snapshot.mask?.frame = snapshot.bounds
            view.insertSubview(snapshot, aboveSubview: tabBar)
        }

        self.barSnapshot = snapshot
    }

    func animateNavigationTransition(to direction: TabBarTransitionDirection) {
        let width = tabBar.bounds.width
        switch direction {
        case .left:
            tabBar.mask?.transform = .identity
            barSnapshot?.mask?.transform = CGAffineTransform(translationX: -width, y: 0)
        case .right:
            tabBar.mask?.transform = .identity
            barSnapshot?.mask?.transform = CGAffineTransform(translationX: width, y: 0)
        }
    }

    func cleanUpNavigationTransition() {
        tabBar.mask = nil
        barSnapshot?.removeFromSuperview()
    }
}

extension UIViewController {

    @objc(cute_tabBarTheme)
    var tabBarTheme: CuteTabBarTheme {
        return .light
    }
}
