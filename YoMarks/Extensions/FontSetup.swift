//
//  FontSetup.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

class FontSetup {
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
    
    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: size)!
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
}
