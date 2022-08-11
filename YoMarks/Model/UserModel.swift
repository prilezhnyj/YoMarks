//
//  UserModel.swift
//  YoMarks
//
//  Created by Максим Боталов on 11.08.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct UsersModel: Hashable, Decodable {
    var email: String
    var uid: String
    
    var representation: [String: Any] {
        var rep = ["email": email]
        rep["uid"] = uid
        return rep
    }
    
    init(email: String, uid: String) {
        self.email = email
        self.uid = uid
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let email = data["email"] as? String else { return nil }
        guard let uid = data["uid"] as? String else { return nil }
        
        self.email = email
        self.uid = uid
    }
}
