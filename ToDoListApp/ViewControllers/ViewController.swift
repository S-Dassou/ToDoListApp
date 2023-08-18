//
//  ViewController.swift
//  ToDoListApp
//
//  Created by shafique dassu on 21/02/2023.
//

import UIKit
import RealmSwift


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
 
    lazy var emptyStateView: EmptyStateView = {
        let view = UINib(nibName: "EmptyStateView", bundle: nil).instantiate(withOwner: self)[0] as! EmptyStateView
        return view
    }()
    

    var tasks: [Task] = [] {
        didSet {
            emptyStateView.isHidden = tasks.count != 0
        }
    }
    
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
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "com.shafiquedassu.refresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTaskFromNotification(_:)), name: NSNotification.Name("com.shafiquedassu.deleteTask"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTaskFromNotification(_:)), name: NSNotification.Name("com.shafiquedassu.updateTask"), object: nil)
        view.addSubview(emptyStateView)
        view.addSubview(addTaskButton)

        let realm = try! Realm()
        let localTasks = realm.objects(LocalTask.self)
        
        for localTask in localTasks {
            if let category = Category(rawValue: localTask.category) {
                let task = Task(id: localTask.id, title: localTask.taskTitle, description: localTask.taskDescription, category: category, isComplete: localTask.isComplete)
                tasks.append(task)
            }
        }
        
        if tasks.count > 0 {
            tableView.reloadData()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topSafeAreaMargin = view.safeAreaInsets.top
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let bottomSafeAreaMargin = view.safeAreaInsets.bottom
        let adjustmentForFloat: CGFloat = 120
        let emptyStateHeight = view.frame.height - topSafeAreaMargin - navigationBarHeight - bottomSafeAreaMargin - adjustmentForFloat
        let yPosEmptyStateView = topSafeAreaMargin + navigationBarHeight
        emptyStateView.frame = CGRect(x: 0, y: yPosEmptyStateView, width: view.frame.width, height: emptyStateHeight)
    }
    
    @objc func updateTaskFromNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
        let index = userInfo["index"] as? Int,
           let task = userInfo["task"] as? Task {
      
            let realm = try! Realm()
            if let localTask = realm.object(ofType: LocalTask.self, forPrimaryKey: task.id) {
                localTask.taskTitle = task.title
                localTask.taskDescription = task.description
                localTask.category = task.category.rawValue
                
            }
            try! realm.write {
                
            }
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
        print("button tapped")
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
        let realm = try! Realm()
        let task = tasks[index]
        task.toggleIsComplete()
        if let localTask = realm.object(ofType: LocalTask.self, forPrimaryKey: task.id) {
            try! realm.write {
                localTask.isComplete = task.isComplete
            }
        }
        tableView.reloadData()
    }
}

//MARK: - TableView data source
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tasks.count == 0 {
//            return 1
//        }
        //if i uncomment above code, 2 empty state views appear... why? returning 1 empty state view cell that is repeating.
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tasks.count == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateTableViewCell", for: indexPath) as! EmptyStateTableViewCell
//            return cell
//        } else {
            let task = tasks[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel.text = task.title
            cell.categoryLabel.text = task.category.rawValue
            cell.descriptionLabel.text = task.description
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
            let realm = try! Realm()
            let task = tasks[indexPath.row]
            if let localTask = realm.object(ofType: LocalTask.self, forPrimaryKey: task.id) {
                try! realm.write {
                    realm.delete(localTask)
                }
            }
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
    
    
    //MARK: - Change row height
    extension ViewController: UITableViewDelegate {
        
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 80
//        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "TaskDetailSegue", sender: indexPath.row)
        }
        
    }


