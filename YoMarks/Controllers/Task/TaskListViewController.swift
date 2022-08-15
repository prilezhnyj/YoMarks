//
//  TaskListViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 07.08.2022.
//

import UIKit
import FirebaseAuth

class TaskListViewController: UIViewController {
    
    // MARK: Property
    private let currentUser: User
    private var tasksArray = [TaskModel]()
    
    // MARK: ViewControllers and UI-components
    private let newTaskVC = NewTaskViewController()
    private let searchController = UISearchController()
    private let taskTableView = UITableView(backgroundColor: ColorSetup.background(), separatorColor: .clear)
    
    // MARK: Custom Initializer
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentUser.email!)
        title = "Welcome"
        view.backgroundColor = ColorSetup.background()
        navigationItem.backButtonTitle = "Back"
        
        setupConstraints()
        setupShearchBar()
        setupTableView()
        
        newTaskVC.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: currentUser.email, style: .plain, target: self, action: #selector(userInfo))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addNewTask))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(1)) {
            self.getAllTasks()
            self.taskTableView.reloadData()
        }
    }
    
    // MARK: Getting data from the «Firebase» database
    private func getAllTasks() {
        FirestoreServices.shared.allGetData(user: currentUser) { result in
            switch result {
            case .success(let data):
                self.tasksArray = data
                self.taskTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup ShearchBar + Delegate
extension TaskListViewController: UISearchBarDelegate {
    private func setupShearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Start typing..."
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

// MARK: - Setup TaskTableView
extension TaskListViewController {
    private func setupTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(TaskMaxCell.self, forCellReuseIdentifier: TaskMaxCell.cellID)
        taskTableView.register(TaskMinCell.self, forCellReuseIdentifier: TaskMinCell.cellID)
    }
}

// MARK: - Setup target and @objc functions
extension TaskListViewController {
    @objc private func userInfo() {
        let alertController = UIAlertController(title: "User Information", message: "You are logged in under the user \(currentUser.email!). Do you want to log out or continue using the app?", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "Exit", style: .destructive) { _ in
            FirebaseAuth.shared.signOut {
                self.dismiss(animated: true)
            }
        }
        let staylAction = UIAlertAction(title: "Stay", style: .default)
        alertController.addAction(exitAction)
        alertController.addAction(staylAction)
        present(alertController, animated: true)
    }
    
    @objc private func addNewTask() {
        present(newTaskVC, animated: true)
    }
}

// MARK: - SaveTaskProtocol
extension TaskListViewController: SaveTaskProtocol {
    func saveTask(title: String, description: String) {
        FirestoreServices.shared.addData(user: currentUser, title: title, description: description) { result in
            switch result {
            case .success(_):
                self.getAllTasks()
                self.taskTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasksArray[indexPath.row]
        
        guard task.description == "" else {
            let cellMax = tableView.dequeueReusableCell(withIdentifier: TaskMaxCell.cellID, for: indexPath) as! TaskMaxCell
            cellMax.config(task: task)
            return cellMax
        }
        
        let cellMin = tableView.dequeueReusableCell(withIdentifier: TaskMinCell.cellID, for: indexPath) as! TaskMinCell
        cellMin.config(task: task)
        return cellMin
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let task = tasksArray[indexPath.row]
        
        guard task.description == "" else { return 90 }
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Setting up constraints and auto layout
extension TaskListViewController {
    private func setupConstraints() {
        view.addSubview(taskTableView)
        NSLayoutConstraint.activate([
            taskTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}
