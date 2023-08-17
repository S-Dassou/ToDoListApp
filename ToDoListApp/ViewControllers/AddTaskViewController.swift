//
//  AddTaskViewController.swift
//  ToDoListApp
//
//  Created by shafique dassu on 10/03/2023.
//

import UIKit
import RealmSwift

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    
    weak var delegate: AddTaskDelegate?
    var task: Task?
    var index: Int?
    lazy var categories: [Category] = {
        return Category.allCases
    } ()
    var shadowColor: UIColor = .gray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ATVC appeared")
        //change colour
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        if let task = task {
            titleLabel.text = "Edit Task"
            titleTextField.text = task.title
            descriptionTextView.text = task.description
            let taskCategory = task.category
            var row = categories.firstIndex { queryCategory in
                queryCategory == taskCategory
            }
            if let row = row {
                categoryPickerView.selectRow(row, inComponent: 0 , animated: false)
            }
        }
        modalView.layer.cornerRadius = 6
        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.cornerRadius = 6
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 6
        submitButton.layer.cornerRadius = 5
        submitButton.layer.shadowColor = shadowColor.cgColor
        submitButton.layer.shadowOpacity = 1.0
        submitButton.layer.shadowRadius = 0
        submitButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        modalView.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        UIView.animate(withDuration: 0.25, delay: 0) {
//            self.modalView.transform = CGAffineTransform(scaleX: 1, y: 1)
//        }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: [.curveEaseOut]) {
            self.modalView.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { success in
            
        }

    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text else {
            return
        }
        guard let description = descriptionTextView.text else {
            return 
        }
        let selectedPickerViewRow = categoryPickerView.selectedRow(inComponent: 0)
        let selectedCategory = categories[selectedPickerViewRow]
        
        
        /*
         saving to Realm
         */
        
        if let oldTask = task,
            let index = index {
            let updatedTask = Task(id: oldTask.id, title: title, description: description, category: selectedCategory)
            NotificationCenter.default.post(name: NSNotification.Name("com.shafiquedassu.updateTask"), object: nil, userInfo: ["index": index, "task": updatedTask])
        } else {
            let taskId = UUID().uuidString
            let newTask = Task(id: taskId, title: title, description: description, category: selectedCategory)
            let realm = try! Realm()
            let localTask = LocalTask()
            localTask.id = taskId
            localTask.taskTitle = title
            localTask.taskDescription = description
            localTask.category = selectedCategory.rawValue
            
            try! realm.write({
                realm.add(localTask)
            })
            delegate?.add(task: newTask)
        }
        dismiss(animated: true)
        
        
    }
    
    @IBAction func dismissAddTask(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension AddTaskViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
}

extension AddTaskViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            pickerLabel?.textAlignment = .center
        }
        let titleOfCategory = categories[row]
        pickerLabel?.text = titleOfCategory.rawValue
        return pickerLabel!
    }
}
