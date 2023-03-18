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
    
    var tasks: [Task] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddTaskViewController
        destinationVC.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "CreateTaskSegue", sender: nil)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

//MARK: - Change row height
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    
}
