//
//  ViewController.swift
//  ToDoListApp
//
//  Created by shafique dassu on 21/02/2023.
//

import UIKit

class Task {
    let title: String
    let description: String
    let category: Category
    var  isComplete: Bool
    init(title: String, description: String, category: Category, isComplete: Bool = false) {
        self.title = title
        self.description = description
        self.category = category
        self.isComplete = isComplete
    }
    func toggleIsComplete() {
        isComplete = !isComplete
    }
}

protocol AddTaskDelegate: AnyObject {
    func add(task: Task)
}

protocol ViewControllerDelegate: AnyObject {
    func toggleIsComplete(forindex index: Int)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var addTaskButton: UIButton = {
        let viewHeight = view.frame.height
        let buttonHeight: CGFloat = 80
        let buttonWidth: CGFloat = 80
        let viewWidth = view.frame.width
        let button = UIButton()
        
        button.backgroundColor = UIColor.link
        button.setImage(UIImage(systemName: "plus") , for: .normal)
        button.tintColor = UIColor.white
        button.imageView?.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.4)
        button.layer.cornerRadius = buttonHeight / 2
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.frame = CGRect(x: (viewWidth / 2) - (buttonWidth / 2), y: (viewHeight - buttonHeight - 40), width: buttonWidth, height: buttonHeight)
        return button
    }()
 
    
    var selectedIndex: Int = 0
    var tasks: [Task] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CreateTaskSegue" {
            let destinationVC = segue.destination as! AddTaskViewController
            destinationVC.delegate = self
        }
        else if segue.identifier == "TaskDetailSegue" {
            let destinationVC = segue.destination as! TaskDetailViewController
            let index = sender as! Int
            let selectedTask = tasks[index]
            destinationVC.task = selectedTask
            destinationVC.index = index
            destinationVC.delegate = self
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "com.shafiquedassu.refresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTaskFromNotification(_:)), name: NSNotification.Name("com.shafiquedassu.deleteTask"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTaskFromNotification(_:)), name: NSNotification.Name("com.shafiquedassu.updateTask"), object: nil)
        
        let viewHeight = view.frame.height
        let buttonHeight: CGFloat = 90
        let buttonWidth: CGFloat = 90
        let viewWidth = view.frame.width
        
        addTaskButton.backgroundColor = UIColor.link
        addTaskButton.setImage(UIImage(systemName: "plus") , for: .normal)
        addTaskButton.tintColor = UIColor.white
        addTaskButton.imageView?.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1.4)
        addTaskButton.layer.cornerRadius = buttonHeight / 2
       
        addTaskButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        addTaskButton.frame = CGRect(x: (viewWidth / 2) - (buttonWidth / 2), y: (viewHeight - buttonHeight - 40), width: buttonWidth, height: buttonHeight)
        view.addSubview(addTaskButton)
    }
    
    @objc func updateTaskFromNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
        let index = userInfo["index"] as? Int,
           let task = userInfo["task"] as? Task {
            tasks[index] = task
            tableView.reloadData()
        }
    }
    
    @objc func deleteTaskFromNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
        let index = userInfo["index"] as? Int {
            tasks.remove(at: index)
            tableView.reloadData()
        }
    }
    
   @objc func refresh() {
        tableView.reloadData()
    }
    
 
    
    @objc func addButtonTapped() {
        performSegue(withIdentifier: "CreateTaskSegue", sender: nil)
    }
    
        }

extension ViewController: TaskDetailDelegate {
    func deleteTask(index: Int) {
        tasks.remove(at: index)
        tableView.reloadData()
    }
}

extension ViewController: AddTaskDelegate {
    
    func add(task: Task) {
        self.tasks.append(task)
        tableView.reloadData()
    }
}

extension ViewController: ViewControllerDelegate {
    func toggleIsComplete(forindex index: Int) {
        let taskSelected = tasks[index] //look into this line
        taskSelected.toggleIsComplete()
        tableView.reloadData()
    }
}

//MARK: - TableView data source
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if tasks.count == 0 {
                return 1
            }
            return 0
        }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateTableViewCell", for: indexPath)
            return cell
        } else {
            let task = tasks[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
            
            cell.titleLabel.text = task.title
            cell.categoryLabel.text = task.category.rawValue
            cell.delegate = self // (initialise VC var)
            cell.index = indexPath.row
            
            if task.isComplete {
                cell.checkmarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            } else {
                cell.checkmarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 1)], with: .automatic)
        }
    }
    
}

//MARK: - Change row height
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.frame.height
        }
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TaskDetailSegue", sender: indexPath.row)
    }
    
}
