//
//  LoginViewController.swift
//  Todolist
//
//  Created by Oybek on 7/13/21.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - Properties
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
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.textColor = .systemGreen
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
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
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    private lazy var loginStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    // MARK: - Selectors
    @objc private func signUp() {
        let nav = UINavigationController(rootViewController: MainViewController())
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    // MARK: - API
    // MARK: - Functions
    private func configureUI() {
        view.backgroundColor = UIColor(named: "mainBackground")
        lockImageView.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
        
        view.addSubview(lockImageView)
        lockImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        lockImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        lockImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        signInTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(signInTitle)
        signInTitle.topAnchor.constraint(equalTo: lockImageView.bottomAnchor, constant: 10).isActive = true
        signInTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        signInTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        view.addSubview(loginStack)
        loginStack.topAnchor.constraint(equalTo: signInTitle.bottomAnchor, constant: 10).isActive = true
        loginStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        loginStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        
        
        view.addSubview(signUpButton)
//        signUpButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        // make color sets for login items
        // compare design & do small changes
        // switch to the register controller (look at tg)
    }
}
