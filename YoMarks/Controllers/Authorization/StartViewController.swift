//
//  StartViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 07.08.2022.
//

import UIKit
import FirebaseAuth

class StartViewController: UIViewController {
    
    // MARK: - ViewControllers and UI-components
    let signUpVC = SignUpViewController()
    let signInVC = SignInViewController()
    let taskVC = TaskListViewController()
    
    private let greetingLabel = UILabel(text: "YoMarks", textColor: .black, font: FontSetup.bold(size: 46))
    private let descriptionLabel = UILabel(text: "Hello. This is «YoMarks». I'll let you always stay on the work wave and not forget anything!", textColor: .black, font: FontSetup.medium(size: 16))
    
    private let signUpButton = UIButton(titleText: "Sign Up", titleFont: FontSetup.medium(size: 16), titleColor: .white, backgroundColor: .black, isBorder: false, cornerRadius: 10, isShadow: true)
    private let signInButton = UIButton(titleText: "Sign In", titleFont: FontSetup.medium(size: 16), titleColor: .black, backgroundColor: .white, isBorder: true, cornerRadius: 10, isShadow: true)
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupTarget()
        
        signInVC.delegate = self
        signUpVC.delegate = self
    }
}

// MARK: - Setup target and @objc functions
extension StartViewController {
    private func setupTarget() {
        signUpButton.addTarget(self, action: #selector(pushSignUpVC), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(pushSignInVC), for: .touchUpInside)
    }
    
    @objc private func pushSignUpVC() {
        present(signUpVC, animated: true)
    }
    
    @objc private func pushSignInVC() {
        present(signInVC, animated: true)
    }
}

// MARK: - AuthTransitionProtocol: authorization transitions
extension StartViewController: AuthTransitionProtocol {
    func delegatePushSignUpVC() {
        present(signUpVC, animated: true)
    }
    
    func delegatePushSignInVC() {
        present(signInVC, animated: true)
    }
    
    func delegatePushTaskVC() {
        let viewController = createNavigationController(viewController: taskVC)
        present(viewController, animated: true)
    }
}

// MARK: - Setting up constraints and auto layout
extension StartViewController {
    private func setupConstraints() {
        view.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 96),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
        
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
        
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 256),
            signInButton.heightAnchor.constraint(equalToConstant: 48)])
        
        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -8),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 256),
            signUpButton.heightAnchor.constraint(equalToConstant: 48)])
    }
}
