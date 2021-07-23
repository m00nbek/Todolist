//
//  DatabaseManager.swift
//  Todolist
//
//  Created by Oybek on 7/22/21.
//

import Foundation
import Firebase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
        
    public func currentSafeEmail() -> String {
        guard let currentEmail = Auth.auth().currentUser?.email else {fatalError()}
        var safeEmail = currentEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
// MARK: - Delete Todo
extension DatabaseManager {
    public func deleteTodo(index: Int) {
        if index == 0 {
            print("You cannot delete first item!")
            return
        }
        database.child(currentSafeEmail()).child("todos").observeSingleEvent(of: .value) { snapshot in
            if var todos = snapshot.value as? [[String: Any]] {
                todos.remove(at: index)
                self.database.child(self.currentSafeEmail()).child("todos").setValue(todos) { error, _ in
                    if error != nil {
                        print("Error occured while deleting todo from db")
                        return
                    }
                    print("Successfully deletd todo from db")
                }
            } else {
                print("Can't cast down todos")
            }
        }
    }
}
// MARK: - UpdateTodo
extension DatabaseManager {
    public func updateTodo(index: Int) {
        if index == 0 {
            print("You cannot update first item!")
            return
        }
        database.child(currentSafeEmail()).child("todos").child("\(index)").observeSingleEvent(of: .value) { snapshot in
            if let todo = snapshot.value as? [String: Any] {
                if var isCompleted = todo["isCompleted"] as? Bool {
                    isCompleted.toggle()
                    self.database.child(self.currentSafeEmail()).child("todos").child("\(index)").updateChildValues(["isCompleted": isCompleted])
                }
            }
        }
    }
}
// MARK: - FetchTodos
extension DatabaseManager {
    public func fetchTodos(completion: @escaping([Todo]) -> Void) {
        database.child(currentSafeEmail()).child("todos").observeSingleEvent(of: .value) { snapshot in
            if let todos = snapshot.value as? [[String: Any]] {
                var resultTodos = [Todo]()
                for todo in todos {
                    if let title = todo["title"] as? String, let isCompleted = todo["isCompleted"] as? Bool {
                        let todo = Todo(title: title, isCompleted: isCompleted)
                        resultTodos.append(todo)
                    }
                }
                // remove the first item from the array
                resultTodos.removeFirst()
                
                completion(resultTodos)
            } else {
                print("Can't get todos data from snapshot")
            }
        }
    }
}
// MARK: - InsertTodo
extension DatabaseManager {
    public func insertTodo(todo: Todo) {
        /// insert todo function is gonna insert todo into db for that specific email
       database.child(currentSafeEmail()).child("todos").observeSingleEvent(of: .value) { snapshot in
            // if todos exist then append new todo into the db for specific email
            if var todos = snapshot.value as? [[String: Any]] {
                // append to todos dictionary
                let newTodo: [String : Any] = [
                    "title": todo.title,
                    "isCompleted": todo.isCompleted
                ]
                todos.append(newTodo)
                self.database.child(self.currentSafeEmail()).child("todos").setValue(todos) { error, _ in
                    if error != nil {
                        print("Error occured while inserting todo into db")
                        return
                    }
                    print("Successfully inserted todo into db")
                }
            } else {
                print("Can't cast it down")
            }
        }
    }
}
// MARK: - Insert User
extension DatabaseManager {
    public func insertUser(with email: String, completion: @escaping(Bool) -> Void) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.observeSingleEvent(of: .value) { snapshot in
            if let _ = snapshot.value as? [String: Any] {
                self.database.child(safeEmail).setValue(
                    [
                        "todos": [
                            [
                                "title" : "This is your new todo",
                                "isCompleted" : false
                            ]
                        ]
                    ], withCompletionBlock: { error, _ in
                    if error != nil {
                        completion(false)
                        print("Error occured while inserting user into db")
                        return
                    }
                    completion(true)
                    print("Successfully inserted user into db")
                }
                )
                
            } else {
                let users: [String: Any] =
                    [
                        safeEmail: [
                            "todos": [
                                [
                                    "title" : "This is your new todo",
                                    "isCompleted" : false
                                ]
                            ]
                        ]
                    ]
                self.database.setValue(users) { error, _ in
                    if error != nil {
                        completion(false)
                        print("Error occured while inserting users collection into db")
                        return
                    }
                    completion(true)
                    print("Successfully inserted users collection into db")
                }
            }
        }
    }
}
// MARK: - User existance
extension DatabaseManager {
    public func userExists(with email: String, completion: @escaping((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}


