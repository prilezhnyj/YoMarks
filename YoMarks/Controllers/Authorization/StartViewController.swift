//
//  StartViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 07.08.2022.
//

import UIKit
import FirebaseAuth

class StartViewController: UIViewController {
    
    //
    // MARK: ViewControllers and UI-components
    let signUpVC = SignUpViewController()
    let signInVC = SignInViewController()
    
    private let greetingLabel = UILabel(text: "YoTasks", textColor: ColorSetup.purpleDark(), font: FontSetup.bold(size: 34))
    private let descriptionLabel = UILabel(text: "Hello. This is «YoTasks». I'll let you always stay on the work wave and not forget anything!", textColor: ColorSetup.black(), font: FontSetup.regular(size: 17))
    
    private let signUpButton = UIButton(titleText: "Sign Up", titleFont: FontSetup.bold(size: 17), titleColor: ColorSetup.white(), backgroundColor: ColorSetup.purpleDark(), isBorder: false, cornerRadius: 15, isShadow: true, shadowColor: ColorSetup.purpleDark())
    private let signInButton = UIButton(titleText: "Sign In", titleFont: FontSetup.bold(size: 17), titleColor: ColorSetup.orange(), backgroundColor: ColorSetup.white(), isBorder: true, cornerRadius: 15, isShadow: true, borderColor: ColorSetup.orange(), shadowColor: ColorSetup.orange())
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSetup.white()
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
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true)
    }
    
    @objc private func pushSignInVC() {
        signInVC.modalPresentationStyle = .fullScreen
        present(signInVC, animated: true)
    }
}

// MARK: - AuthTransitionProtocol: authorization transitions
extension StartViewController: AuthTransitionProtocol {
    func delegatePushSignUpVC() {
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true)
    }
    
    func delegatePushSignInVC() {
        signInVC.modalPresentationStyle = .fullScreen
        present(signInVC, animated: true)
    }
    
    func delegatePushTaskVC(for user: User) {
        let taskVC = TaskListViewController(currentUser: user)
        let taskNavVC = createNavigationController(viewController: taskVC)
        present(taskNavVC, animated: true)
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
            descriptionLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 8),
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
            signUpButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -16),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 256),
            signUpButton.heightAnchor.constraint(equalToConstant: 48)])
    }
}
