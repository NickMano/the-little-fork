//
//  Colors.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit

extension UIColor {
    static let accent = UIColor(hex: "68934C") ?? .green
    private static let raisinBlack = UIColor(hex: "1E2334") ?? .black
    private static let oxford = UIColor(hex: "191D2C") ?? .black
    private static let ghostWhite = UIColor(hex: "F4F6FA") ?? .white

    static var principal = UIColor().getColor(lightMode: .white, darkMode: .raisinBlack)
    static var secondary = UIColor().getColor(lightMode: .ghostWhite, darkMode: .oxford)
}

private extension UIColor {
    /**
     Initialzer based on hex string.
     
     - parameter hexString: It can either be uppercase or lowercase
        and contain or not a leading # and specify or not the alpha component.
    */
    convenience init?(hex: String) {
        let red, green, blue, alpha: CGFloat

        let start: String.Index
        if hex.hasPrefix("#") {
            start = hex.index(hex.startIndex, offsetBy: 1)
        } else {
            start = hex.startIndex
        }

        var hexColor = String(hex[start...])

        if hexColor.count == 6 {
            hexColor.append("ff")
        }

        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                alpha = CGFloat(hexNumber & 0x000000ff) / 255

                self.init(red: red, green: green, blue: blue, alpha: alpha)
                return
            }
        }
        return nil
    }

    func getColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return darkMode
            } else {
                return lightMode
            }
        }
    }
}
