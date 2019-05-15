//
//  AddExamViewController.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/26/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit

class AddExamViewController: UIViewController {

    @IBOutlet weak var addExamDatePicker: UIDatePicker!
    @IBOutlet weak var examDescriptionTextField: UITextField!
    @IBOutlet weak var examLocationTextField: UITextField!
    @IBOutlet weak var saveNewExamButton: UIButton!
    
    var course: Course!
    var exam: Exam!
    var userDocumentID: String!
    var courseDocumentID: String!
    var dateOfExam: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exam = Exam()
        
        addBordersToButtons()
        addBordersToLabelsAndTextFields()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addBordersToButtons() {
        saveNewExamButton.addBorder(width: 1.0, radius: 5.0, color: .black)
    }
    
    func addBordersToLabelsAndTextFields() {
        examDescriptionTextField.addBorder(width: 1.0, radius: 5.0, color: .gray)
        examLocationTextField.addBorder(width: 1.0, radius: 5.0, color: .gray)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dateOfExam = addExamDatePicker.date
        print("Date picker value changed!!!")
        print("Date of exam: \(dateOfExam)")
    }
    
    @IBAction func saveNewExamDatePressed(_ sender: UIButton) {
        guard dateOfExam != nil else {
            showAlert(title: "No Exam Date Selected", message: "Select an exam date before saving.")
            return
        }
        exam.examDate = dateOfExam.timeIntervalSince1970
        exam.examLocation = examLocationTextField.text!
        exam.examDescription = examDescriptionTextField.text!
        print("%%%%%% currentDocumentID: \(userDocumentID), courseDocumentID: \(courseDocumentID)")
        print("New exam just saved: exam.examLocation: \(exam.examLocation) exam.examID: \(exam.examID)")
        exam.saveExamData(currentDocumentID: userDocumentID, courseIDForSaving: courseDocumentID) { success in
            if success {
                print("New exam date and description successfully saved!")
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
}



