//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

final class CuteTabBarTheme: NSObject {
    let selectedColor: UIColor
    let deselectedColor: UIColor
    let backgroundColor: UIColor

    init(selectedColor: UIColor, deselectedColor: UIColor, backgroundColor: UIColor) {
        self.selectedColor = selectedColor
        self.deselectedColor = deselectedColor
        self.backgroundColor = backgroundColor
    }

    static let gray: CuteTabBarTheme = CuteTabBarTheme(selectedColor: .cuteRed,
                                                       deselectedColor: .lightGray,
                                                       backgroundColor: .white)
    static let transparent: CuteTabBarTheme = CuteTabBarTheme(selectedColor: .white,
                                                              deselectedColor: .lightGray,
                                                              backgroundColor: .clear)
}


final class CuteTabBarController: UITabBarController {

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
        tabBar.isTranslucent = true
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }

    private func reloadTabBarStyle() {
        guard let theme = selectedViewController?.tabBarTheme else {
            return
        }

        tabBar.tintColor = theme.selectedColor
        tabBar.barTintColor = theme.backgroundColor

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
        return .gray
    }
}
