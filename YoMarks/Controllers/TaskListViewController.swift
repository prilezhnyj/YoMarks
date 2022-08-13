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
    private var tasks = [TaskModel]()
    
    // MARK: ViewControllers and UI-components
    private let editTaskVC = DescriptionTaskViewController()
    private let searchController = UISearchController()
    private let taskTableView = UITableView(backgroundColor: ColorSetup.background(), separatorColor: .clear)
    private var categoriesCollectionView: UICollectionView!
    
    // MARK: Custom Initializer
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        view.backgroundColor = ColorSetup.background()
        navigationItem.backButtonTitle = "Back"
        
        setupCollectionView()
        setupConstraints()
        setupTarget()
        setupTableView()
        setupShearchBar()
        
        editTaskVC.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: currentUser.email, style: .plain, target: self, action: #selector(userInfo))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addNewTask))
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(1)) {
            self.getTasts()
        }
    }
    
    // MARK: Getting data from the «Firebase» database
    private func getTasts() {
        FirestoreServices.shared.getData(user: currentUser) { result in
            switch result {
            case .success(let data):
                self.tasks = data
                self.taskTableView.reloadData()
            case .failure(_):
                print("Ошибка")
            }
        }
    }
    
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

// MARK: - Setup CollectionView
extension TaskListViewController {
    private func setupCollectionView() {
        categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        categoriesCollectionView.backgroundColor = ColorSetup.background()
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.showsVerticalScrollIndicator = false
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.cellID)
        categoriesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "endCell")
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 6
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .horizontal
        return layout
    }
}

// MARK: - Setup target and @objc functions
extension TaskListViewController {
    private func setupTarget() {}
    
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
        present(editTaskVC, animated: true)
    }
}

// MARK: - SaveTaskProtocol
extension TaskListViewController: SaveTaskProtocol {
    func saveTask(title: String, description: String) {
        FirestoreServices.shared.addData(user: currentUser, title: title, description: description) { result in
            switch result {
            case .success(_):
                print("Успех")
                self.getTasts()
                self.taskTableView.reloadData()
            case .failure(_):
                print("Ошибка")
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TaskListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.cellID, for: indexPath) as! CategoryCell
        return cell
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        
        if task.description == "" {
            let cellMin = tableView.dequeueReusableCell(withIdentifier: TaskMinCell.cellID, for: indexPath) as! TaskMinCell
            cellMin.config(task: task)
            return cellMin
        } else {
            let cellMax = tableView.dequeueReusableCell(withIdentifier: TaskMaxCell.cellID, for: indexPath) as! TaskMaxCell
            let task = tasks[indexPath.row]
            cellMax.config(task: task)
            return cellMax
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let task = tasks[indexPath.row]
        
        if task.description == "" {
            return 56
        } else {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskTitle = tasks[indexPath.row].title
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            FirestoreServices.shared.deleteData(user: self.currentUser, title: taskTitle) { check in
                if check == true {
                    self.tasks.remove(at: indexPath.row)
                    self.taskTableView.reloadData()
                }
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        navigationController?.pushViewController(descVC, animated: true)
    }
}

// MARK: - Setting up constraints and auto layout
extension TaskListViewController {
    private func setupConstraints() {
        view.addSubview(categoriesCollectionView)
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 60)])
        
        view.addSubview(taskTableView)
        NSLayoutConstraint.activate([
            taskTableView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 12),
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}
