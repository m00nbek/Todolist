//
//  MainTableViewController.swift
//  Todolist
//
//  Created by Oybek on 7/13/21.
//

import UIKit
import Firebase
import JGProgressHUD

class MainViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authUserAndUpdateUI()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser?.uid != nil {
            fetchTodos()
        }
    }
    // MARK: - Authentication Functions
    private func authUserAndUpdateUI() {
        if Auth.auth().currentUser?.uid == nil {
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        } else {
            fetchTodos()
        }
    }
    // MARK: - Properties
    var todos = [Todo]() {
        didSet {
            tableView.reloadData()
        }
    }
    private let spinner = JGProgressHUD(style: .dark)
    private lazy var alert: UIAlertController = {
        var alert = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        var alertTextField = UITextField()
        alert.addTextField { textField in
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "Add New Task"
            alertTextField = textField
            alertTextField.delegate = self
            alertTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            // append new item to the array & reloadData()
            guard let text = alertTextField.text else {return}
            if !text.replacingOccurrences(of: " ", with: "").isEmpty {
                let newTodo = Todo(title: text, isCompleted: false)
                self?.createTodo(todo: newTodo)
                self?.todos.append(newTodo)
                self?.tableView.reloadData()
                alertTextField.text = nil
            }
        }
        action.isEnabled = false
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }()
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
        tableView.backgroundColor = UIColor(named: "mainBackground")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let newTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Add new task", for: .normal)
        button.titleLabel?.textColor = .systemGreen
        button.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var logOutButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.target = self
        button.action = #selector(logOut)
        button.title = "Log Out"
        return button
    }()
    // MARK: - Selectors
    @objc private func logOut() {
        spinner.show(in: view)
        do {
            try Auth.auth().signOut()
            authUserAndUpdateUI()
            spinner.dismiss()
        } catch {
            print("Can't log out")
        }
    }
    @objc private func addNewTask() {
        present(alert, animated: true, completion: nil)
    }
    // MARK: - API
    private func updateTodo(index: Int) {
        DatabaseManager.shared.updateTodo(index: index + 1)
    }
    private func createTodo(todo: Todo) {
        DatabaseManager.shared.insertTodo(todo: todo)
    }
    private func fetchTodos() {
        // fetch and set todos arr
        spinner.show(in: view)
        DatabaseManager.shared.fetchTodos { todos in
            self.todos = todos
        }
        spinner.dismiss()
    }
    // MARK: - Functions
    private func configureUI() {
        
        
        view.backgroundColor = UIColor(named: "mainBackground")
        tableView.register(TodoCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.setRightBarButton(logOutButton, animated: true)
        
        paperFolderImageView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        
        view.addSubview(paperFolderImageView)
        paperFolderImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
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
        
        view.addSubview(newTaskButton)
        newTaskButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10).isActive = true
        newTaskButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        newTaskButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        newTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}

// MARK: - UITableViewDelegate/DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TodoCell else {
            fatalError("Could not create cell")
        }
        cell.todoIndex = indexPath.row
        cell.todoText = todos[indexPath.row].title
        cell.delegate = self
        cell.isCompleted = todos[indexPath.row].isCompleted
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        todos[indexPath.row].isCompleted.toggle()
        updateTodo(index: indexPath.row)
    }
    
}
// MARK: - TodoCellDelegate
extension MainViewController: TodoCellDelegate {
    func deleteItemAt(_ index: Int) {
        print("Deleting item")
        todos.remove(at: index)
        DatabaseManager.shared.deleteTodo(index: index + 1)
        tableView.reloadData()
    }
}
// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {return}
        if !text.replacingOccurrences(of: " ", with: "").isEmpty {
            alert.actions[0].isEnabled = true
        } else {
            alert.actions[0].isEnabled = false
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {return}
        if !text.replacingOccurrences(of: " ", with: "").isEmpty {
            alert.actions[0].isEnabled = true
        } else {
            alert.actions[0].isEnabled = false
        }
    }
}
