//
//  AddTaskViewController.swift
//  ToDoListApp
//
//  Created by shafique dassu on 10/03/2023.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    weak var delegate: AddTaskDelegate?
    
    lazy var categories: [Category] = {
        return Category.allCases
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = false
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        // Do any additional setup after loading the view.
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
        let newTask = Task(title: title, description: description, category: selectedCategory)
        delegate?.add(task: newTask)
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
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let titleOfCategory = categories[row]
        return titleOfCategory.rawValue
    }
}
