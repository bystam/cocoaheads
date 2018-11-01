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

    static let light: CuteTabBarTheme = CuteTabBarTheme(selectedColor: .darkPurple,
                                                        deselectedColor: .lightGray,
                                                        backgroundColor: UIColor(red: (253.0 / 255),
                                                                                 green: (248.0 / 255),
                                                                                 blue: (255.0 / 255),
                                                                                 alpha: 1.0),
                                                        hasShadow: true)
    static let transparent: CuteTabBarTheme = CuteTabBarTheme(selectedColor: .white,
                                                              deselectedColor: .lightGray,
                                                              backgroundColor: .clear,
                                                              hasShadow: false)
}


final class CuteTabBarController: UITabBarController {

    private let barShadowView: UIView = {
        let view = UIView()
        view.autoresizingMask = [.flexibleBottomMargin]
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        return view
    }()

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

    private func reloadTabBarStyle() {
        guard let theme = selectedViewController?.tabBarTheme else {
            return
        }

        tabBar.tintColor = theme.selectedColor
        tabBar.isTranslucent = theme.backgroundColor.isClear
        tabBar.barTintColor = theme.backgroundColor
        barShadowView.isHidden = !theme.hasShadow

        viewControllers?
            .compactMap { $0.tabBarItem }
            .forEach { paint($0, with: theme) }
    }

    private func paint(_ item: UITabBarItem, with theme: CuteTabBarTheme) {
        item.selectedImage = item.selectedImage?.tinted(with: theme.selectedColor)
        item.image = item.image?.tinted(with: theme.deselectedColor)
    }
}

extension UIViewController {

    @objc(cute_tabBarTheme)
    var tabBarTheme: CuteTabBarTheme {
        return .light
    }
}
