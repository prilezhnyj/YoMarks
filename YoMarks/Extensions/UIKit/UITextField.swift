//
//  UITextField.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

extension UITextField {
    convenience init(placeholder: String, isSecure: Bool, initialLetter:  UITextAutocapitalizationType = .none) {
        self.init()
        self.isSecureTextEntry = isSecure
        self.autocapitalizationType = initialLetter
        self.placeholder = placeholder
        self.autocorrectionType = .no
        self.returnKeyType = .done
        self.borderStyle = .roundedRect
        self.clearButtonMode = .always
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
