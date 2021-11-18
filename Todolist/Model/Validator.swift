//
//  Validator.swift
//  Validator
//
//  Created by Oybek on 7/25/21.
//

import UIKit

class Validator {
    
    // MARK: - Lifecycle
    init(emailContainerView: UIView, passwordContainerView: UIView, fullnameContainerView: UIView? = nil, button: UIButton) {
        self.emailContainer = emailContainerView
        self.passwordContainer = passwordContainerView
        self.button = button
        self.fullnameContainer = fullnameContainerView
    }
    // MARK: - regexValidation
    var isValidEmail: Bool?
    var isValidPass: Bool?
    var isValidFullname: Bool?
    let emailContainer: UIView
    let passwordContainer: UIView
    var fullnameContainer: UIView?
    let button: UIButton
    func regexValidation(textField: UITextField) {
        if !textField.text!.isEmpty {
            if fullnameContainer == nil {
                // for Login
                if textField.placeholder == "Email" {
                    print("Checking email")
                    if isValidEmail(textField.text!) && !textField.text!.contains(" ") {
                        print("Email is valid")
                        isValidEmail = true
                        updateUI(isValid: true, in: emailContainer, for: button)
                    } else {
                        isValidEmail = false
                        updateUI(isValid: false, in: emailContainer, for: button)
                    }
                } else if textField.placeholder == "Password" {
                    if textField.text!.count >= 6 && !textField.text!.contains(" ") {
                        isValidPass = true
                        updateUI(isValid: true, in: passwordContainer, for: button)
                    } else {
                        isValidPass = false
                        updateUI(isValid: false, in: passwordContainer, for: button)
                    }
                }
            } else {
                if textField.placeholder == "Full name" {
                    if textField.text!.count >= 3 {
                        isValidFullname = true
                        updateUI(isValid: true, in: fullnameContainer!, for: button)
                    } else {
                        isValidFullname = false
                        updateUI(isValid: false, in: fullnameContainer!, for: button)
                    }
                } else if textField.placeholder == "Email" {
                    if isValidEmail(textField.text!) && !textField.text!.contains(" ") {
                        isValidEmail = true
                        updateUI(isValid: true, in: emailContainer, for: button)
                    } else {
                        isValidEmail = false
                        updateUI(isValid: false, in: emailContainer, for: button)
                    }
                } else if textField.placeholder == "Password" {
                    if textField.text!.count >= 6 && !textField.text!.contains(" ") {
                        isValidPass = true
                        updateUI(isValid: true, in: passwordContainer, for: button)
                    } else {
                        isValidPass = false
                        updateUI(isValid: false, in: passwordContainer, for: button)
                    }
                }
            }
        } else {
            if fullnameContainer == nil {
                if textField.placeholder == "Email" {
                    updateUI(isValid: false, in: emailContainer, for: button)
                } else {
                    updateUI(isValid: false, in: passwordContainer, for: button)
                }
            } else {
                if textField.placeholder == "Full name" {
                    updateUI(isValid: false, in: fullnameContainer!, for: button)
                } else if textField.placeholder == "Email" {
                    updateUI(isValid: false, in: emailContainer, for: button)
                } else {
                    updateUI(isValid: false, in: passwordContainer, for: button)
                }
            }
        }
    }
    // MARK: - updateUI
    func updateUI(isValid: Bool, in containerView: UIView, for button: UIButton) {
        print("validator's updating UI")
        if !isValid {
            containerView.layer.borderWidth = 2
            button.alpha = 0.5
            button.isUserInteractionEnabled = false
        } else {
            containerView.layer.borderWidth = 0
        }
        if fullnameContainer == nil {
            // for Login
            if isValidEmail != nil && isValidPass != nil {
                if isValidEmail! && isValidPass! {
                    button.alpha = 1
                    button.isUserInteractionEnabled = true
                }
            }
        } else {
            // for Register
            if isValidEmail != nil && isValidPass != nil && isValidFullname != nil {
                if isValidEmail! && isValidPass! && isValidFullname! {
                    button.alpha = 1
                    button.isUserInteractionEnabled = true
                }
            }
        }
    }
    // MARK: - isValidEmail
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
