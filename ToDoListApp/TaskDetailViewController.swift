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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var toggleTaskCompletionButton: UIButton!
    var task: Task?
    var index: Int?
    var delegate: TaskDetailDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = task {
            titleLabel.text = task.title
            categoryLabel.text = task.category.rawValue
            descriptionLabel.text = task.description
            let toggleButtonTitle = task.isComplete ? "Mark Task Incomplete" : "Mark Task Complete"
            toggleTaskCompletionButton.setTitle(toggleButtonTitle, for: .normal)
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
        task.isComplete.toggle()
        let toggleButtonTitle = task.isComplete ? "Mark Task Incomplete" : "Mark Task Complete"
        toggleTaskCompletionButton.setTitle(toggleButtonTitle, for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.shafiquedassu.refresh"), object: nil)
    }
    
    @IBAction func editTaskButtonTapped(_ sender: Any) {
    }
    
}
