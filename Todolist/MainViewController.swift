//
//  MainTableViewController.swift
//  Todolist
//
//  Created by Oybek on 7/13/21.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authUserAndUpdateUI()
        configureUI()
    }
    // MARK: - Authentication Functions
    private func authUserAndUpdateUI() {
        if !isLoggedIn {
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(nav, animated: true)
        }
    }
    // MARK: - Properties
    private var isLoggedIn = true
    private var todos = [Todo]()
    
    private let paperFolderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "paper_folder")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let todoTitle: UILabel = {
        let label = UILabel()
        label.text = "To Do list"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let newTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Add new task", for: .normal)
        button.titleLabel?.textColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Selectors
    // MARK: - API
    // MARK: - Functions
    private func configureUI() {
        todos.append(Todo(title: "New task1", isCompleted: false))
        todos.append(Todo(title: "New task2", isCompleted: false))
        todos.append(Todo(title: "New task3", isCompleted: false))
        
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        paperFolderImageView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        
        view.addSubview(paperFolderImageView)
        paperFolderImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        paperFolderImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        paperFolderImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        todoTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(todoTitle)
        todoTitle.topAnchor.constraint(equalTo: paperFolderImageView.bottomAnchor, constant: 10).isActive = true
        todoTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        todoTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: todoTitle.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

// MARK: - UITableViewDelegate/DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        todos[indexPath.row].isCompleted.toggle()
        
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        let attributeString = NSMutableAttributedString(string: todos[indexPath.row].title)
        attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        if todos[indexPath.row].isCompleted {
            cell.textLabel?.text = nil
            cell.textLabel?.attributedText = attributeString
        } else {
            cell.textLabel?.attributedText = nil
            cell.textLabel?.text = todos[indexPath.row].title
        }
    }
    
}
