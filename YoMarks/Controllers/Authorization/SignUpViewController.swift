//
//  SignUpViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    weak var delegate: AuthTransitionProtocol!
    
    // MARK: - UI-components
    private let greetingLabel = UILabel(text: "Welcome", textColor: .black, font: FontSetup.bold(size: 46))
    private let descriptionLabel = UILabel(text: "These are applications for keeping track of your cases and tasks. With him, you will never miss an important meeting or forget to do any business.", textColor: .black, font: FontSetup.medium(size: 16))
    
    private let emailTextField = UITextField(placeholder: "Your email", isSecure: false, initialLetter: .none)
    private let passwordTextField = UITextField(placeholder: "Your password", isSecure: false, initialLetter: .none)
    private let repeatPasswordTextField = UITextField(placeholder: "Your password again", isSecure: false, initialLetter: .none)
    
    private let signUpButton = UIButton(titleText: "Finish registration", titleFont: FontSetup.medium(size: 16), titleColor: .white, backgroundColor: .black, isBorder: false, cornerRadius: 10, isShadow: true)
    private let signInButton = UIButton(titleText: "Have an account? Sign In", titleFont: FontSetup.medium(size: 16), titleColor: .black, backgroundColor: .white, isBorder: true, cornerRadius: 10, isShadow: true)
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupTarget()
    }
}

//MARK: - Setup target and @objc functions
extension SignUpViewController {
    private func setupTarget() {
        signUpButton.addTarget(self, action: #selector(finishRegistration), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(pushSignInVC), for: .touchUpInside)
    }
    
    @objc private func finishRegistration() {
        FirebaseAuth.shared.singUp(email: emailTextField.text, password: passwordTextField.text, repeatPassword: repeatPasswordTextField.text) { result in
            switch result {
            case .success(let user):
                self.showAlert(with: "Success", and: "User «\(user.email!)» has been successfully created.") {
                    self.dismiss(animated: true) {
                        self.delegate?.delegatePushTaskVC(for: user)
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func pushSignInVC() {
        dismiss(animated: true) {
            self.delegate.delegatePushSignInVC()
        }
    }
}

// MARK: - Setting up constraints and auto layout
extension SignUpViewController {
    private func setupConstraints() {
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 48),
            signInButton.widthAnchor.constraint(equalToConstant: 256)])
        
        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -8),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
            signUpButton.widthAnchor.constraint(equalToConstant: 256)])
        
        let textFieldsStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, repeatPasswordTextField], distribution: .equalSpacing, axis: .vertical, spacing: 8)
        
        view.addSubview(textFieldsStackView)
        NSLayoutConstraint.activate([
            textFieldsStackView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -32),
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
