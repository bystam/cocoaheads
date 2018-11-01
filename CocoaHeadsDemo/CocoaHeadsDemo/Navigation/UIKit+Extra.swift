//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

extension UIColor {

    static var darkPurple: UIColor = UIColor(red: (71.0 / 255),
                                             green: (17.0 / 255),
                                             blue: (144.0 / 255),
                                             alpha: 1.0)

    var isClear: Bool {
        var alpha: CGFloat = 0.0
        getWhite(nil, alpha: &alpha)
        return alpha < 0.0000001
    }
}

extension UIImage {

    func tinted(with color: UIColor) -> UIImage {
        let image: UIImage = self
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.clip(to: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height), mask: image.cgImage!)
        context?.fill(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        return UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
    }
}
