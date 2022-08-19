//
//  CustomTextField.swift
//  YoMarks
//
//  Created by Максим Боталов on 18.08.2022.
//

import UIKit

class CustomTextField: UIView {
    
    let textField = UITextField(placeholder: "", isSecure: false)
    
    convenience init(bgColor: UIColor, keyboardType: UIKeyboardType, isSecure: Bool, placeholder: String = "") {
        self.init()
        self.backgroundColor = bgColor
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.keyboardType = keyboardType
        textField.borderStyle = .none
        textField.textColor = ColorSetup.white()
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: ColorSetup.placeholder()])
        
        
        if keyboardType == .emailAddress || keyboardType == .URL {
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        } else {
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .yes
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)])
    }
}
