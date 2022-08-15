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
    let title: String
    let description: String
    var id = UUID().uuidString
    
    var representation: [String: Any] {
        var rep = ["title": title]
        rep["description"] = description
        return rep
    }
}
