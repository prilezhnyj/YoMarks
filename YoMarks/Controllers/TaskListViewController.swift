//
//  TaskListViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 07.08.2022.
//

import UIKit

class TaskListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Welcome"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction))
    }
    
    @objc private func logoutAction() {
        showAlert(with: "Attention", and: "Are you sure you want to exit the app?", okayButton: "Yes", cancelButton: "No") {
            self.dismiss(animated: true)
        }
    }
}


