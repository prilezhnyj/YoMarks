//
//  UIImage.swift
//  YoMarks
//
//  Created by Максим Боталов on 17.08.2022.
//

import UIKit

class SystemImage {
    static func close() -> UIImage {
        return UIImage(systemName: "xmark")!
    }
    
    static func trash() -> UIImage {
        return UIImage(systemName: "trash")!
    }
}
