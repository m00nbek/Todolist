//
//  Utilities.swift
//  Todolist
//
//  Created by Oybek on 7/17/21.
//

import UIKit

class Utilities {
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        // Properties
        let view: UIView = {
            let view = UIView()
            view.layer.borderColor = UIColor.red.cgColor
            view.heightAnchor.constraint(equalToConstant: 50).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
            iv.image = image
            iv.tintColor = UIColor(named: "imageViewTintColor")
            return iv
        }()
        let dividerView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(named: "dividerViewColor")
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
            return view
        }()
        let stackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [imageView, textField])
            stack.axis = .horizontal
            stack.spacing = 8
            stack.distribution = .fillProportionally
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        // Adding properties to the view
        view.addSubview(dividerView)
        view.addSubview(stackView)
        // Constraints
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: dividerView.topAnchor).isActive = true
        
        dividerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dividerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    
        return view
    }
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = UIColor(named: "textFieldColor")
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        return tf
    }
}
