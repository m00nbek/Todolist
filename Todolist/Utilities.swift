//
//  Utilities.swift
//  Todolist
//
//  Created by Oybek on 7/17/21.
//

import UIKit

class Utilities {
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false

        let iv = UIImageView()
        iv.image = image
        iv.contentMode = .scaleAspectFit
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        
        dividerView.translatesAutoresizingMaskIntoConstraints = false
//        iv.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dividerView)
//        view.addSubview(iv)
//        view.addSubview(textField)
        
//        iv.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
//        iv.bottomAnchor.constraint(equalTo: dividerView.topAnchor, constant: 8).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
//
//        textField.leftAnchor.constraint(equalTo: iv.rightAnchor, constant: 8).isActive = true
//        textField.bottomAnchor.constraint(equalTo: dividerView.topAnchor, constant: 8).isActive = true
//        textField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        let stack = UIStackView(arrangedSubviews: [iv, textField])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: dividerView.topAnchor).isActive = true
        
        
        dividerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dividerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        return view
    }
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }
}
