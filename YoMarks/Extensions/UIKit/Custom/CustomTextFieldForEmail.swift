//
//  CustomTextFieldForEmail.swift
//  YoMarks
//
//  Created by Максим Боталов on 19.08.2022.
//

import UIKit

class CustomTextFieldForEmail: UIView {
    
    let textField = UITextField(placeholder: "", isSecure: false)
    
    let downLine: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.backgroundColor = ColorSetup.purpleDark()
        view.layer.shadowColor = ColorSetup.purpleDark().cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    convenience init(keyboardType: UIKeyboardType, isSecure: Bool, placeholder: String = "") {
        self.init()
        self.backgroundColor = ColorSetup.white()
        textField.font = FontSetup.medium(size: 17)
        textField.textColor = ColorSetup.black()
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.keyboardType = keyboardType
        textField.borderStyle = .none
        textField.textColor = ColorSetup.black()
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: ColorSetup.placeholder()])
        
        
        if keyboardType == .emailAddress || keyboardType == .URL {
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        } else {
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .yes
        }
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorSetup.white()
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
        
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        downLine.layer.cornerRadius = downLine.frame.height / 2
        downLine.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 30)])
        
        self.addSubview(downLine)
        NSLayoutConstraint.activate([
            downLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            downLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            downLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            downLine.heightAnchor.constraint(equalToConstant: 2)])
    }
}
