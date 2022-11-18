//
//  UITableViewCell+Extension.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 18/11/2022.
//

import UIKit

extension UITableViewCell {
    /// Returns the identifier of the cell as a String.
    static var identifier: String {
        return String(describing: self)
    }
}
