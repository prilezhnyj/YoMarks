//
//  FirebaseAuth.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import Foundation
import FirebaseAuth

class FirebaseAuth {
    static let shared = FirebaseAuth()
    
    private let auth = Auth.auth()
    
    func singUp(email: String?, password: String?, repeatPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard ValidateAuth.checkFields(email: email, password: password, repeatPassword: repeatPassword) else {
            completion(.failure(ErrorAuth.notField))
            return
        }
        
        guard ValidateAuth.checkEmail(email: email) else {
            completion(.failure(ErrorAuth.invalidEmail))
            return
        }
        
        guard password?.lowercased() == repeatPassword?.lowercased() else {
            completion(.failure(ErrorAuth.passwordNotMatched))
            return
        }
        
        guard ValidateAuth.checkPassword(password) else {
            completion(.failure(ErrorAuth.invalidPassword))
            return
        }
        
        // MARK: createUser
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let user = result?.user else {
                completion(.failure(error!))
                return
            }
            
            FirestoreServices.shared.saveUser(email: email!, uid: user.uid) { result in
                switch result {
                case .success(_):
                    completion(.success(user))
                case .failure(_):
                    completion(.failure(error?.localizedDescription as! Error))
                }
            }
        }
    }
    
    func signIn(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard ValidateAuth.checkFields(email: email, password: password) else {
            completion(.failure(ErrorAuth.notField))
            return
        }
        
        guard ValidateAuth.checkEmail(email: email) else {
            completion(.failure(ErrorAuth.invalidEmail))
            return
        }
        
        guard ValidateAuth.checkPassword(password) else {
            completion(.failure(ErrorAuth.invalidPassword))
            return
        }
        
        // MARK: signIn
        auth.signIn(withEmail: email!, password: password!) { result, error in
            guard let user = result?.user else {
                completion(.failure(error!))
                return
            }
            completion(.success(user))
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
