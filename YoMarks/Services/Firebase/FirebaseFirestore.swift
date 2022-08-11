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
}
