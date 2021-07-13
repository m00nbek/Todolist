//
//  TodoCell.swift
//  Todolist
//
//  Created by Oybek on 7/13/21.
//

import UIKit

class TodoCell: UITableViewCell {
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    // MARK: - Properties
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("x", for: .normal)
        button.titleLabel?.textColor = .lightGray
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()
    // MARK: - Selectors
    @objc private func deleteTapped() {
        // delete item from array
    }
    // MARK: - API
    // MARK: - Functions
    func toggleIsCompleted() {
        let attributeString =  NSMutableAttributedString(string: (textLabel?.text!)!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        textLabel?.attributedText = attributeString
    }

}
