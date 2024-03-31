//
//  ViewController.swift
//  TaskList
//
//  Created by Дарья Кобелева on 28.03.2024.
//

import UIKit

final class TaskListViewController: UITableViewController {
    
    //MARK: - Private Properties
    private let storageManager = StorageManager.shared
    private var taskList: [ToDoTask] = []
    private let cellID = "task"
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableViewReload()
    }
    
    //MARK: - Private Methods
    @objc private func addNewTask() {
        showAlert(with: "New Task", andMessage: "What do you want to do?", for: nil)
    }
    
    private func showAlert(with title: String, andMessage message: String, for task: ToDoTask?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let textFieldText = task?.title ?? ""
        
        alert.addTextField { textField in
            textField.textColor = .darkGray
            textField.text = textFieldText.isEmpty ? nil : textFieldText
            textField.placeholder = textFieldText.isEmpty ? "New Task" : nil
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let inputText = alert.textFields?.first?.text, !inputText.isEmpty else { return }
            if let task = task {
                storageManager.update(task, withNewTitle: inputText)
            } else {
                storageManager.create(inputText)
            }
            tableViewReload()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func tableViewReload() {
        taskList = storageManager.fetchData()
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskList[indexPath.row]
            storageManager.delete(task)
            tableViewReload()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = taskList[indexPath.row]
        showAlert(with: "Edit Task", andMessage: "What do you want to do?", for: task)
    }
}

//MARK: - Setup UI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = .milkPink
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance //Режим прокрутки
        
        //Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
}


