//
//  TodoCell.swift
//  Todolist
//
//  Created by Oybek on 7/13/21.
//

import UIKit

protocol TodoCellDelegate {
    func deleteItemAt(_ index: Int)
}
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
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(view)
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        view.addSubview(circleImageView)
        view.addSubview(deleteButton)
        view.addSubview(todoTextLabel)
        
        circleImageView.layer.cornerRadius = 40/2
        circleImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        circleImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        circleImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        circleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        circleImageView.trailingAnchor.constraint(equalTo: todoTextLabel.leadingAnchor, constant: -10).isActive = true
        
        
        todoTextLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        todoTextLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        todoTextLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -10).isActive = true
        
        
        deleteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    // MARK: - Properties
    var delegate: TodoCellDelegate?
    var todoIndex: Int?
    var todoText: String?
    var isCompleted: Bool? {
        didSet {
            guard let todoText = todoText else {
                return
            }
            todoTextLabel.attributedText = nil
            if isCompleted! {
                let attributeString = NSMutableAttributedString(string: todoText)
                attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                
                circleImageView.image = UIImage(named: "checkmark")
                todoTextLabel.text = nil
                todoTextLabel.attributedText = attributeString
                print("UI changed for completed state")
            } else {
                circleImageView.image = nil
                todoTextLabel.attributedText = nil
                todoTextLabel.text = todoText
                print("UI changed for not completed state")
            }
        }
    }
    let todoTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let circleImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.borderWidth = 1
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setTitle("x", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.titleLabel?.textColor = .lightGray
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Selectors
    @objc private func deleteTapped() {
        // delete item from array
        guard let todoIndex = todoIndex else {return}
        delegate?.deleteItemAt(todoIndex)
        removeFromSuperview()
    }
    // MARK: - API
    // MARK: - Functions
}
