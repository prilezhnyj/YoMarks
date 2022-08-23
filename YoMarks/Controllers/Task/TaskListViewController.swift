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
    private let refreshControl = UIRefreshControl()
    
    // MARK: ViewControllers and UI-components
    private let newTaskVC = NewTaskViewController()
    private let searchController = UISearchController()
    private let taskTableView = UITableView(backgroundColor: ColorSetup.white(), separatorColor: .clear)
    
    // MARK: Custom Initializer
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "👋🏻 Welcome"
        view.backgroundColor = ColorSetup.white()
        navigationItem.backButtonTitle = "Back to tasks"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorSetup.purpleDark()]
        navigationController?.navigationBar.tintColor = ColorSetup.purpleDark()
        
        userUpload()
        addTarget()
        
        setupConstraints()
        setupShearchBar()
        setupTableView()
        
        newTaskVC.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Update tasks")
        refreshControl.tintColor = ColorSetup.purpleDark()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "User: \(currentUser.email!)", style: .plain, target: self, action: #selector(userInfo))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addNewTask))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(1)) {
            self.getAllTasks()
            self.taskTableView.reloadData()
        }
    }
    
    // MARK: Lifecycle viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(1)) {
            self.getAllTasks()
            self.taskTableView.reloadData()
        }
    }
    
    // MARK: User upload
    private func userUpload() {
        print("-------------------------------------------------------------------------")
        print("The application has been successfully downloaded. The user data is below.")
        print("User email: \(currentUser.email!)")
        print("User id: \(currentUser.uid)")
        print("-------------------------------------------------------------------------")
    }
    
    // MARK: Getting data from the «Firebase» database
    private func getAllTasks() {
        FirestoreServices.shared.allGetData(user: currentUser) { result in
            switch result {
            case .success(let data):
                var array = data
                array.sort { !$0.status && $1.status }
                self.tasksArray = array
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
        taskTableView.refreshControl = refreshControl
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.register(TaskMaxCell.self, forCellReuseIdentifier: TaskMaxCell.cellID)
        taskTableView.register(TaskMinCell.self, forCellReuseIdentifier: TaskMinCell.cellID)
        taskTableView.register(DoneTaskCell.self, forCellReuseIdentifier: DoneTaskCell.cellID)
    }
}

// MARK: - Setup target and @objc functions
extension TaskListViewController {
    private func addTarget() {
        refreshControl.addTarget(self, action: #selector(updateTableView), for: .valueChanged)
    }
    
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
        let vc = createNavigationControllerModalPresent(viewController: newTaskVC, nameItem: "", nameImageItem: "")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func updateTableView() {
        getAllTasks()
        taskTableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - SaveTaskProtocol
extension TaskListViewController: SaveTaskProtocol {
    func saveTask(title: String, description: String) {
        FirestoreServices.shared.addData(user: currentUser, title: title, description: description) { result in
            switch result {
            case .success(let data):
                print(data)
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
        
        if task.status == true {
            let doneCell = tableView.dequeueReusableCell(withIdentifier: DoneTaskCell.cellID, for: indexPath) as! DoneTaskCell
            doneCell.config(task: task)
            return doneCell
        } else {
            guard task.description == "" else {
                let cellMax = tableView.dequeueReusableCell(withIdentifier: TaskMaxCell.cellID, for: indexPath) as! TaskMaxCell
                cellMax.config(task: task)
                return cellMax
            }
            
            let cellMin = tableView.dequeueReusableCell(withIdentifier: TaskMinCell.cellID, for: indexPath) as! TaskMinCell
            cellMin.config(task: task)
            return cellMin
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let task = tasksArray[indexPath.row]
        
        if task.status == false {
            guard task.description == "" else { return 88 }
            return 56
        } else {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let task = self.tasksArray[indexPath.row]
            FirestoreServices.shared.deleteData(user: self.currentUser, task: task) { check in
                if check == true {
                    self.tasksArray.remove(at: indexPath.row)
                    self.taskTableView.deleteRows(at: [indexPath], with: .automatic)
                    self.taskTableView.reloadData()
                }
            }
            self.taskTableView.reloadData()
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            let task = self.tasksArray[indexPath.row]
            let editTaskVC = EditTaskViewController(user: self.currentUser, task: task)
            self.navigationController?.pushViewController(editTaskVC, animated: true)
        }
        delete.image = SystemImage.trash()
        delete.backgroundColor = ColorSetup.orange()
        edit.image = SystemImage.edit()
        edit.backgroundColor = ColorSetup.green()
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasksArray[indexPath.row]
        
        if task.status == false {
            let updateTask = TaskModel(title: task.title, description: task.description, id: task.id, status: true)
            FirestoreServices.shared.updatingOneTask(user: currentUser, task: updateTask) { result in
                switch result {
                case .success(let data):
                    self.tasksArray.remove(at: indexPath.row)
                    self.tasksArray.append(data)
                    tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            let updateTask = TaskModel(title: task.title, description: task.description, id: task.id, status: false)
            FirestoreServices.shared.updatingOneTask(user: currentUser, task: updateTask) { result in
                switch result {
                case .success(let data):
                    self.tasksArray.remove(at: indexPath.row)
                    self.tasksArray.insert(data, at: 0)
                    tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
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
