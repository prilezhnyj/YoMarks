//
//  SignInViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

class SignInViewController: UIViewController {
    
    weak var delegate: AuthTransitionProtocol?
    
    private var contentViewSize: CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: UI-components
    private let greetingLabel = UILabel(text: "Come back", textColor: .black, font: FontSetup.bold(size: 46))
    private let descriptionLabel = UILabel(text: "Log in to access your tasks and offer a job.", textColor: .black, font: FontSetup.medium(size: 16))
    
    private let emailTextField = CustomTextField(bgColor: .white, keyboardType: .emailAddress, isSecure: false, placeholder: "Your email")
    private let passwordTextField = CustomTextField(bgColor: .white, keyboardType: .default, isSecure: true, placeholder: "Your password")
    
    private let signUpButton = UIButton(titleText: "No account? Sign Up", titleFont: FontSetup.medium(size: 16), titleColor: .black, backgroundColor: ColorSetup.background(), isBorder: true, cornerRadius: 24, isShadow: true)
    private let signInButton = UIButton(titleText: "Sign In", titleFont: FontSetup.medium(size: 16), titleColor: .white, backgroundColor: .black, isBorder: false, cornerRadius: 24, isShadow: true)
    private let closeButton = UIButton(image: SystemImage.arrowLeft(), colorImage: .white, backgroundColor: .black, isBorder: false, cornerRadius: 24, isShadow: true)
    
    private lazy var bgScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = ColorSetup.background()
        scrollView.contentSize = contentViewSize
        scrollView.frame = view.bounds
        return scrollView
    }()
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSetup.background()
        view.frame.size = contentViewSize
        return view
    }()
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSetup.background()
        setupConstraints()
        setupTarget()
        registerNotificationKeyboard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        conteinerView.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        removeNotificationKeyboard()
    }
}

//MARK: - Setup target and @objc functions
extension SignInViewController {
    private func setupTarget() {
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(pushSignInVC), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(finishAuth), for: .touchUpInside)
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc private func finishAuth() {
        FirebaseAuth.shared.signIn(email: emailTextField.textField.text, password: passwordTextField.textField.text) { result in
            switch result {
            case .success(let user):
                self.showAlert(with: "Success", and: "User «\(user.email!)» successfully logged in.") {
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
            self.delegate?.delegatePushSignUpVC()
        }
    }
    
    @objc private func tapGestureAction() {
        emailTextField.textField.resignFirstResponder()
        passwordTextField.textField.resignFirstResponder()
    }
    
    @objc private func keyboardShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        bgScrollView.contentOffset = CGPoint(x: 0, y: keyboardFrame.size.height - 24)
    }
    
    @objc private func keyboardHide() {
        bgScrollView.contentOffset = CGPoint.zero
    }
}

// MARK: - KeyboardWillShowNotification & KeyboardWillHideNotification
extension SignInViewController {
    private func registerNotificationKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotificationKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Setting up constraints and auto layout
extension SignInViewController {
    private func setupConstraints() {
        view.addSubview(bgScrollView)
        bgScrollView.addSubview(conteinerView)
        
        conteinerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: conteinerView.safeAreaLayoutGuide.topAnchor, constant: 32),
            closeButton.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            closeButton.widthAnchor.constraint(equalToConstant: 48),
            closeButton.heightAnchor.constraint(equalToConstant: 48)])
        
        conteinerView.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.bottomAnchor.constraint(equalTo: conteinerView.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            signUpButton.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
            signUpButton.widthAnchor.constraint(equalToConstant: 256)])

        conteinerView.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -8),
            signInButton.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 48),
            signInButton.widthAnchor.constraint(equalToConstant: 256)])

        let textFieldsStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField], distribution: .fillEqually, axis: .vertical, spacing: 8)

        conteinerView.addSubview(textFieldsStackView)
        NSLayoutConstraint.activate([
            textFieldsStackView.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -32),
            textFieldsStackView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            textFieldsStackView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32),
            textFieldsStackView.heightAnchor.constraint(equalToConstant: 108)])

        conteinerView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: textFieldsStackView.topAnchor, constant: -32),
            descriptionLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])

        conteinerView.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            greetingLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])
    }
}
