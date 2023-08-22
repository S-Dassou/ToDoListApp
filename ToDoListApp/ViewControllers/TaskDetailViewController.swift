//
//  TaskDetailViewController.swift
//  ToDoListApp
//
//  Created by shafique dassu on 19/03/2023.
//

import UIKit

protocol TaskDetailDelegate: AnyObject {
    func deleteTask(index: Int)
}

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var categoryDetailContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var toggleTaskCompletionButton: UIButton!
    @IBOutlet weak var editTaskButton: UIButton!
    
    var task: Task?
    var index: Int?
    var shadowColor: UIColor = .gray
    weak var delegate: TaskDetailDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddTaskViewController
        let task = sender as! Task
        destinationVC.task = task
        destinationVC.index = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = task {
           setupTaskDetail(task: task)
           configureDetailView(task: task)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateTaskFromNotification(_:)), name: NSNotification.Name("com.shafiquedassu.updateTask"), object: nil)
  
        editTaskButton.layer.cornerRadius = 5
        editTaskButton.layer.shadowColor = shadowColor.cgColor
        editTaskButton.layer.shadowOpacity = 1.0
        editTaskButton.layer.shadowRadius = 0
        editTaskButton.layer.shadowOffset = CGSize(width: 0, height: 5)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryDetailContainerView.layer.cornerRadius = categoryDetailContainerView.frame.height / 2
    }
    
    // function to configure the inputs and functionality of task detail
    func setupTaskDetail(task: Task) {
        titleLabel.text = task.title
        categoryLabel.text = task.category.rawValue
        descriptionLabel.text = task.description
        
        if task.isComplete {
            toggleTaskCompletionButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        } else {
            toggleTaskCompletionButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
//        let toggleButtonTitle = task.isComplete ? "Mark Task Incomplete" : "Mark Task Complete"
//        toggleTaskCompletionButton.setTitle(toggleButtonTitle, for: .normal)
    }
    
    // configuring the layout and design of the detail
    func configureDetailView(task: Task) {
        categoryDetailContainerView.backgroundColor = task.category.secondaryColor
        categoryLabel.textColor = task.category.color
        
        self.task = task
    }
    
    @objc func updateTaskFromNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let task = userInfo["task"] as? Task {
            setupTaskDetail(task: task)
        }
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
//            if let index = self.index {
//                self.delegate?.deleteTask(index: index)
//
//            }
            if let index = self.index {
                NotificationCenter.default.post(name: NSNotification.Name("com.shafiquedassu.deleteTask"), object: nil, userInfo: ["index": index])
            }
            
            self.navigationController?.popViewController(animated: true)
    }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    @IBAction func toggleTaskCompletionButtonTapped(_ sender: Any) {
        guard let task = task else { return }
        print("tapped")
        task.isComplete.toggle()
        if task.isComplete {
            toggleTaskCompletionButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        } else {
            toggleTaskCompletionButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        
        
//        task.isComplete.toggle()
//        let toggleButtonTitle = task.isComplete ? "Mark Task Incomplete" : "Mark Task Complete"
//        toggleTaskCompletionButton.setTitle(toggleButtonTitle, for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.shafiquedassu.refresh"), object: nil)
    }
    
    @IBAction func editTaskButtonTapped(_ sender: Any) {
        guard let task = task else { return }
        performSegue(withIdentifier: "EditTaskSegue", sender: task)
    }
    
}
