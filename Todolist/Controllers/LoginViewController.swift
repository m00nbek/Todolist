//
//  LoginViewController.swift
//  Todolist
//
//  Created by Oybek on 7/13/21.
//

import UIKit
import Firebase
import JGProgressHUD

class LoginViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureUI()
    }
    // MARK: - Properties
    private lazy var validator = Validator(emailContainerView: emailContainerView, passwordContainerView: passwordContainerView, button: signInButton)
    private var lockHeightAnchor: NSLayoutConstraint?
    private let spinner = JGProgressHUD(style: .dark)
    private let lockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lock")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let signInTitle: UILabel = {
        let label = UILabel()
        label.text = "Sign in"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let showSignUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 15)])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [.font: UIFont.boldSystemFont(ofSize: 15)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitleColor(UIColor(named: "lightGreen"), for: .normal)
        button.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var emailContainerView: UIView = {
//        guard let image = UIImage(systemName: "envelope") else {fatalError()}
        guard let image = UIImage(named: "mail") else {fatalError()}
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()
    private lazy var passwordContainerView: UIView = {
//        guard let image = UIImage(systemName: "lock") else {fatalError()}
        guard let image = UIImage(named: "lock_icon") else {fatalError()}
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.textContentType = .password
        tf.isSecureTextEntry = true
        return tf
    }()
    private lazy var loginTextFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let forgotPasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Forgot password?", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private let signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign in →", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(named: "lightGreen")
        btn.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        btn.isUserInteractionEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private lazy var loginButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [forgotPasswordButton, signInButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    // MARK: - Selectors
    @objc private func forgotPassword() {
        
    }
    @objc private func showSignUp() {
        let vc = RegisterViewController()
        vc.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func signIn() {
        if signInButton.alpha == 1 {
            spinner.show(in: view)
            guard let email = emailTextField.text?.lowercased() else {return}
            guard let password = passwordTextField.text?.lowercased() else {return}
            
            DatabaseManager.shared.userExists(with: email) { exists in
                if exists {
                    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                        if error != nil {
                            print("Error occured while signing in user")
                            return
                        }
                        print("Successfully signed in")
                        self?.spinner.dismiss()
                        self?.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.spinner.dismiss()
                    let alert = UIAlertController(title: "User not found", message: "Do you want to Sign Up?", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Sign Up", style: .default) { action in
                        // show the register Controller
                        self.showSignUp()
                    }
                    alert.addAction(action)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    // MARK: - API
    // MARK: - Functions
    private func configureUI() {
        // textField delegates
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.backgroundColor = UIColor(named: "mainBackground")
        
        
        view.addSubview(lockImageView)
        lockHeightAnchor = lockImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        // the multiplier 0.3 means we are setting height of topViewForImage to the 30% of view's height.
        lockHeightAnchor?.isActive = true
        
        lockImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        lockImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        lockImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        signInTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(signInTitle)
        signInTitle.topAnchor.constraint(equalTo: lockImageView.bottomAnchor, constant: 10).isActive = true
        signInTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        signInTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        view.addSubview(loginTextFieldStack)
        loginTextFieldStack.topAnchor.constraint(equalTo: signInTitle.bottomAnchor, constant: 10).isActive = true
        loginTextFieldStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        loginTextFieldStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        
        loginButtonStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(loginButtonStack)
        loginButtonStack.topAnchor.constraint(equalTo: loginTextFieldStack.bottomAnchor, constant: 10).isActive = true
        loginButtonStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        loginButtonStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        
        view.addSubview(showSignUpButton)
        showSignUpButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        showSignUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        showSignUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
        lockHeightAnchor?.isActive = false
        lockHeightAnchor = self.lockImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5)
        lockHeightAnchor?.isActive = true
        UIView.animate(withDuration: 0.5) {
           self.view.layoutIfNeeded()
        }
    }
}
// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("didBegin checking")
        if textField == emailTextField {
            print("Typing email")
            validator.updateUI(isValid: false, in: emailContainerView, for: signInButton)
        } else {
            validator.updateUI(isValid: false, in: passwordContainerView, for: signInButton)
        }
        
        lockHeightAnchor?.isActive = false
        lockHeightAnchor = self.lockImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
        lockHeightAnchor?.isActive = true
        UIView.animate(withDuration: 0.5) {
           self.view.layoutIfNeeded()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signIn()
            lockHeightAnchor?.isActive = false
            lockHeightAnchor = self.lockImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5)
            lockHeightAnchor?.isActive = true
            UIView.animate(withDuration: 0.5) {
               self.view.layoutIfNeeded()
            }
        }
        return true
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        validator.regexValidation(textField: textField)
        
        
//        print("cheeekin")
//        if textField == emailTextField {
//            print("Typing email")
//            validator.updateUI(isValid: false, in: emailContainerView, for: signInButton)
//        } else {
//            validator.updateUI(isValid: false, in: passwordContainerView, for: signInButton)
//        }
//
//        lockHeightAnchor?.isActive = false
//        lockHeightAnchor = self.lockImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
//        lockHeightAnchor?.isActive = true
//        UIView.animate(withDuration: 0.5) {
//            self.view.layoutIfNeeded()
//        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
    }
    
}
