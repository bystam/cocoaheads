//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

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
