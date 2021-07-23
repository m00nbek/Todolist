//
//  RegisterViewController.swift
//  Todolist
//
//  Created by Oybek on 7/13/21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - Properties
    private var validEmail: Bool?
    private var validPass: Bool?
    private var keyHeightAnchor: NSLayoutConstraint?
    private let spinner = JGProgressHUD(style: .dark)
    private let keyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "key")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let signUpTitle: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let showSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor(named: "lightGreen"), for: .normal)
        button.addTarget(self, action: #selector(showSignIn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var emailContainerView: UIView = {
        guard let image = UIImage(systemName: "envelope") else {fatalError()}
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()
    private lazy var passwordContainerView: UIView = {
        guard let image = UIImage(systemName: "lock") else {fatalError()}
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    private lazy var fullnameContainerView: UIView = {
        guard let image = UIImage(systemName: "person") else {fatalError()}
        let view = Utilities().inputContainerView(withImage: image, textField: fullnameTextField)
        return view
    }()
    private let fullnameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Full name")
        tf.textContentType = .password
        return tf
    }()
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    private lazy var loginTextFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullnameContainerView,
                                                   emailContainerView,
                                                   passwordContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up →", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(named: "lightGreen")
        btn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        btn.isUserInteractionEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    // MARK: - Selectors
    @objc private func showSignIn() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func signUp() {
        // Create user
        spinner.show(in: view)
        guard let email = emailTextField.text?.lowercased() else {return}
        guard let password = passwordTextField.text?.lowercased() else {return}
        DatabaseManager.shared.userExists(with: email) { exists in
            if !exists {
                Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                    if error != nil {
                        print("Error occured while creating account")
                        print(error!.localizedDescription)
                        return
                    }
                    print("successfully created account")
                    // create db for that user with email
                    DatabaseManager.shared.insertUser(with: email) { success in
                        if success {
                            // show MainViewController.... dissmiss self
                            self?.spinner.dismiss()
                            self?.dismiss(animated: true, completion: nil)
                        } else {
                            // make red border in the textFields and check for error
                        }
                    }
                }
            } else {
                self.spinner.dismiss()
                let alert = UIAlertController(title: "User already exists", message: "Do you want to Sign In?", preferredStyle: .alert)
                let action = UIAlertAction(title: "Sign In", style: .default) { action in
                    // show the register Controller
                    self.showSignIn()
                }
                alert.addAction(action)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    // MARK: - API
    // MARK: - Functions
    private func configureUI() {
        // textField delegates
        fullnameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.backgroundColor = UIColor(named: "mainBackground")
        
        view.addSubview(keyImageView)
        
        keyHeightAnchor = keyImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45)
        keyHeightAnchor?.isActive = true
        
        keyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        keyImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        keyImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        signUpTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(signUpTitle)
        signUpTitle.topAnchor.constraint(equalTo: keyImageView.bottomAnchor, constant: 10).isActive = true
        signUpTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        signUpTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        view.addSubview(loginTextFieldStack)
        loginTextFieldStack.topAnchor.constraint(equalTo: signUpTitle.bottomAnchor, constant: 10).isActive = true
        loginTextFieldStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        loginTextFieldStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        
        view.addSubview(showSignInButton)
        showSignInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        showSignInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        showSignInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
}
// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        keyHeightAnchor?.isActive = false
        keyHeightAnchor = self.keyImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2)
        keyHeightAnchor?.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullnameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            keyHeightAnchor?.isActive = false
            keyHeightAnchor = self.keyImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.45)
            keyHeightAnchor?.isActive = true
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            
        }
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !textField.text!.isEmpty {
            if textField.placeholder == "Email" {
                if isValidEmail(textField.text!) && !textField.text!.contains(" ") {
                    validEmail = true
                    updateUI(isValid: true, in: emailContainerView)
                } else {
                    validEmail = false
                    updateUI(isValid: false, in: emailContainerView)
                }
            } else if textField.placeholder == "Password" {
                if textField.text!.count >= 6 && !textField.text!.contains(" ") {
                    validPass = true
                    updateUI(isValid: true, in: passwordContainerView)
                } else {
                    validPass = false
                    updateUI(isValid: false, in: passwordContainerView)
                }
            }
        }
    }
    func updateUI(isValid: Bool, in view: UIView = UIView()) {
        if !isValid {
            view.layer.borderWidth = 2
            signUpButton.alpha = 0.5
            signUpButton.isUserInteractionEnabled = false
        } else {
            view.layer.borderWidth = 0
        }
        if validEmail != nil && validPass != nil {
            if validEmail! && validPass! {
                signUpButton.alpha = 1
                signUpButton.isUserInteractionEnabled = true
            }
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailPattern)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count != 0 {
                return true
            } else {
                return false
            }
        } catch {
            fatalError("DEBUG: \(error)")
        }
    }
}
