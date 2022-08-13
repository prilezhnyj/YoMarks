//
//  FirebaseFirestore.swift
//  YoMarks
//
//  Created by Максим Боталов on 11.08.2022.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreServices {
    private init() {}
    
    static let shared = FirestoreServices()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
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
    
    func addData(user: User, title: String, description: String, completion: @escaping (Result<TaskModel, Error>) -> Void) {
        let taskModel = TaskModel(title: title, description: description)
        
        usersRef.document(user.uid).collection("tasks").document(taskModel.title).setData(taskModel.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(taskModel))
            }
        }
    }
    
    func getData(user: User, completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        usersRef.document(user.uid).collection("tasks").getDocuments { snapshot, error in
            var tasksArray = [TaskModel]()
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let title = data["title"] as! String
                    let description = data["description"] as! String
                    let task = TaskModel(title: title, description: description)
                    tasksArray.append(task)
                }
                completion(.success(tasksArray))
            }
        }
    }
    
    func deleteData(user: User, title: String, completion: @escaping (Bool) -> Void) {
        usersRef.document(user.uid).collection("tasks").document(title).delete { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
