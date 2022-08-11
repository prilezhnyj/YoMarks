//
//  TaskListViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 07.08.2022.
//

import UIKit
import FirebaseAuth

class TaskListViewController: UIViewController {
    
    private let currentUser: User
    
    let helloLabel = UILabel(text: "", textColor: .black, font: .systemFont(ofSize: 17))
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Welcome"
        
        helloLabel.text = currentUser.email
        
        view.addSubview(helloLabel)
        helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helloLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc private func logoutAction() {
        print("Выход из системы")
    }
}
