//
//  ViewController.swift
//  ToDoListApp
//
//  Created by shafique dassu on 21/02/2023.
//

import UIKit

class Task {
    let title: String
    let category: String
    var  isComplete: Bool
    init(title: String, category: String, isComplete: Bool) {
        self.title = title
        self.category = category
        self.isComplete = isComplete
    }
    func toggleIsComplete() {
        isComplete = !isComplete
    }
}

protocol ViewControllerDelegate: AnyObject {
    func toggleIsComplete(forindex index: Int)
}

class ViewController: UIViewController, ViewControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!

    var tasks: [Task] = [
    Task(title: "walk", category: "hobby", isComplete: false),
    Task(title: "run", category: "leisure", isComplete: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func toggleIsComplete(forindex index: Int) {
        
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
        cell.categoryLabel.text = task.category
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

//MARK: - Change row height
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let taskSelected = tasks[indexPath.row]
//        taskSelected.toggleIsComplete()
//        tableView.reloadData() //could we put this into the toggle func?
//    }
 
}
//if it was a class: 
//let taskSelected = tasks[IndexPath.row]
//taskSelected.isComplete = !taskSelected.isComplete
//tableView.reloadData()
