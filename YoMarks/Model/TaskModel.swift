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
    var status: Bool = false
    
    func statusStr(status: Bool) -> String {
        if status == true {
            return "completed"
        } else {
            return "planned"
        }
    }
    
    var representation: [String: Any] {
        var rep = ["title": title]
        rep["description"] = description
        rep["id"] = id
        rep["status"] = statusStr(status: status)
        return rep
    }
}
