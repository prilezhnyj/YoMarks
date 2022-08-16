//
//  FirebaseFirestore.swift
//  YoMarks
//
//  Created by Максим Боталов on 11.08.2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class FirestoreServices {
    private init() {}
    
    static let shared = FirestoreServices()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    // Done. Works correctly
    func saveUser(email: String, uid: String, completion: @escaping (Result<UsersModel, Error>) -> Void) {
        let userModel = UsersModel(email: email, uid: uid)
        usersRef.document(userModel.uid).setData(userModel.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(userModel))
            }
        }
    }
    
    // Done. Works correctly
    func getUserData(user: User, complition: @escaping (Result<UsersModel, Error>) -> Void) {
        let docRef = db.collection("users").document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let userModel = UsersModel(document: document) else {
                    complition(.failure(error?.localizedDescription as! Error))
                    return
                }
                complition(.success(userModel))
            } else {
                complition(.failure(UserError.cannotGedUserInfo))
            }
        }
    }
    
    // MARK: - FIRESTORE DATA
    
    // Done. Works correctly
    func addData(user: User, title: String, description: String, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        let taskModel = TaskModel(title: title, description: description, id: UUID().uuidString)
        usersRef.document(user.uid).collection("tasks").document(taskModel.id).setData(taskModel.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(taskModel))
            }
        }
    }
    
    // Done. Works correctly
    func allGetData(user: User, completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        usersRef.document(user.uid).collection("tasks").getDocuments { snapshot, error in
            var tasksArray = [TaskModel]()
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let title = data["title"] as! String
                    let description = data["description"] as! String
                    let id = data["id"] as! String
                    let task = TaskModel(title: title, description: description, id: id)
                    tasksArray.append(task)
                }
                completion(.success(tasksArray))
            }
        }
    }
    
    func getData(user: User, task: TaskModel, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        usersRef.document(user.uid).collection("tasks").document(task.id).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                
                let title = data!["title"] as! String
                let description = data!["description"] as! String
                let id = data!["id"] as! String
                
                let taskModel = TaskModel(title: title, description: description, id: id)
                completion(.success(taskModel))
            }
        }
    }
    
    func updatingData(title: String, description: String, user: User, task: TaskModel, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        usersRef.document(user.uid).collection("tasks").document(task.title).updateData(["title": title, "description": description]) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else {
                print(task)
                completion(.success(task))
            }
        }
    }
    
    // Добработать. Неверный путь и достучаться через uid
    func deleteData(user: User, task: TaskModel, completion: @escaping (Bool) -> Void) {
        usersRef.document(user.uid).collection("tasks").document(task.id).delete { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
