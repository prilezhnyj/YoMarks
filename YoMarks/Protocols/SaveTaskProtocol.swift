//
//  SaveTaskProtocol.swift
//  YoMarks
//
//  Created by Максим Боталов on 13.08.2022.
//

import Foundation

// Protocol for transferring data to the home screen and saving them.
protocol SaveTaskProtocol: AnyObject {
    func saveTask(title: String, description: String)
}
