//
//  TaskModel.swift
//  YoMarks
//
//  Created by Максим Боталов on 12.08.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct TaskModel: Codable {
    var title: String
    var description: String
    var id: String
    
    var representation: [String: Any] {
        var rep = ["title": title]
        rep["description"] = description
        rep["id"] = id
        return rep
    }
}
