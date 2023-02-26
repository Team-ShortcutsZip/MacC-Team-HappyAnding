//
//  UIColor+Extension.swift
//  HappyAnding
//
//  Created by 이지원 on 2023/02/24.
//

import UIKit

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return light
            case .dark:
                return dark
            @unknown default:
                return light
            }
        }
    }
}

extension UIColor {
    static var gray4: UIColor {
        guard let color = UIColor(named: "Grey060") else { return .label }
        return color
    }
    static var gray5: UIColor {
        guard let color = UIColor(named: "Grey070") else { return .label }
        return color
    }
    static var shortcutsZipBackground: UIColor {
        guard let color = UIColor(named: "Grey020") else { return .label }
        return color
    }
    static var shortcutsZipPrimary: UIColor {
        guard let color = UIColor(named: "Primary") else { return .label }
        return color
    }
    static var shortcutsZipPrimaryOpacity: UIColor {
        guard let color = UIColor(named: "Primary") else { return .label }
        return color.withAlphaComponent(0.3)
    }
}
