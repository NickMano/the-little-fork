//
//  Strings+Extension.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 21/11/2022.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "NOT_FOUND")
    }

}
