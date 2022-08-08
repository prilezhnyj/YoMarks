//
//  SignInViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

class SignInViewController: UIViewController {
    
    private let greetingLabel = UILabel(text: "Come back", textColor: .black, font: FontSetup.bold(size: 50))
    private let descriptionLabel = UILabel(text: "Log in to access your tasks and offer a job.", textColor: .black, font: FontSetup.medium(size: 16))
    
    private let emailTextField = UITextField(placeholder: "Your email", isSecure: false, initialLetter: .none)
    private let passwordTextField = UITextField(placeholder: "Your password", isSecure: false, initialLetter: .none)
    
    private let signUpButton = UIButton(titleText: "No account? Sign Up", titleFont: FontSetup.medium(size: 16), titleColor: .black, backgroundColor: .white, isBorder: true, cornerRadius: 10, isShadow: true)
    private let signInButton = UIButton(titleText: "Sign In", titleFont: FontSetup.medium(size: 16), titleColor: .white, backgroundColor: .black, isBorder: false, cornerRadius: 10, isShadow: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }
}

// MARK: - Setting up constraints and auto layout
extension SignInViewController {
    private func setupConstraints() {
        
        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
            signUpButton.widthAnchor.constraint(equalToConstant: 256)])
        
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -8),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 48),
            signInButton.widthAnchor.constraint(equalToConstant: 256)])
        
        let textFieldsStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField], distribution: .equalSpacing, axis: .vertical, spacing: 8)
        
        view.addSubview(textFieldsStackView)
        NSLayoutConstraint.activate([
            textFieldsStackView.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -32),
            textFieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textFieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
        
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: textFieldsStackView.topAnchor, constant: -32),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
        
        view.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
    }
}
