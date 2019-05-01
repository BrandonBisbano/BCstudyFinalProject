//
//  AddCourseViewController.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/16/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit
import Firebase

class AddCourseViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var courseNameInputLabel: UITextField!
    @IBOutlet weak var professorNameInputLabel: UITextField!
    @IBOutlet weak var sectionIDInputLabel: UITextField!
    @IBOutlet var textFieldOutletConnection: [UITextField]!
    @IBOutlet weak var saveNewCourseButton: UIButton!
    
    var course: Course!
    var studyUser: StudyUser!
    var currentUser: StudyUser!
    var classmate: Classmate!
    var bostonCollegeClass: BostonCollegeClass!
    
    var currentDocumentID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        course = Course()
        bostonCollegeClass = BostonCollegeClass()
        
        courseNameInputLabel.delegate = self
        professorNameInputLabel.delegate = self
        sectionIDInputLabel.delegate = self
        
        saveNewCourseButton.isEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func checkField(sender: AnyObject) {
        if courseNameInputLabel.text!.isEmpty == true  || professorNameInputLabel.text!.isEmpty == true || sectionIDInputLabel.text!.isEmpty == true {
            saveNewCourseButton.isEnabled = false
        } else {
            saveNewCourseButton.isEnabled = true
        }
    }

    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateDataFromInterface() {
        course.courseName = courseNameInputLabel.text!
        course.courseID = sectionIDInputLabel.text!
        course.professorName = professorNameInputLabel.text!
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        print("&&&& saveButtonPressed")
        updateDataFromInterface()
        course.saveCourseData(currentDocumentID: currentDocumentID) { success in
            if success {
                print("Successfully saved user's personal course data!")
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
        bostonCollegeClass.courseID = course.courseID
        classmate = Classmate(userID: currentDocumentID)
        classmate.studentName = currentUser.displayName
        classmate.studentEmail = currentUser.email
        if currentUser.photoURL != nil {
            classmate.imageURL = currentUser.photoURL
        } else {
            classmate.imageURL = ""
        }
        classmate.saveStudentInformation(currentDocumentID: currentDocumentID, courseReferenceID: bostonCollegeClass.courseID, classmate: classmate) { (success) in
            if success {
                print("Successfully saved information of the current user to add to classmates collection!")
            } else {
                print("Failed to save information of the current user to add to classmates collection :(")
            }
        }
        print("BostonCollegeClass id for class you just added: \(course.courseID)")
        print("Updated bostonCollegeClass.courseID: \(bostonCollegeClass.courseID)")
        bostonCollegeClass.saveIfNewBostonCollegeClassAndSaveUserInClass(classDocumentID: bostonCollegeClass.courseID, classmate: classmate) { (success) in
            if success {
                print("Successfully saved a new BC class or saved user class data.")
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved after trying to save a new boston college class and save the user in it's classmates array.")
            }
        }
        self.leaveViewController()
    }
}

extension AddCourseViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkField(sender: self)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
}


