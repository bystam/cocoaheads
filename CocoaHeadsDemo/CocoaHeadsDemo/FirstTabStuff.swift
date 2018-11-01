//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var prefersNavigationBarTransparent: Bool {
        return true
    }

    override var tabBarTheme: CuteTabBarTheme {
        return .transparent
    }
}

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
