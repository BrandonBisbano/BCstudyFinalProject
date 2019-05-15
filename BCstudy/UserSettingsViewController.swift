//
//  UserSettingsViewController.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 5/1/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit
import Firebase

class UserSettingsViewController: UIViewController {

    @IBOutlet weak var changePhoneNumberButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var resetCoursesButton: UIButton!
    
    var studyUsers: StudyUsers!
    var studyUser: StudyUser!
    var course: Course!
    var courses: Courses!
    var exam: Exam!
    var exams: Exams!
    var currentUserDocumentID: String = ""
    var examDocumentID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBordersToButtons()
        
        studyUsers = StudyUsers()
        courses = Courses()
        exams = Exams()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AccountDeleted" {
            let destination = segue.destination.children[0] as! MyCoursesTableViewController
            destination.currentUserDocumentID = currentUserDocumentID
        }
    }
    
    func addBordersToButtons() {
        changePhoneNumberButton.addBorder(width: 1.0, radius: 5.0, color: .black)
        resetCoursesButton.addBorder(width: 1.0, radius: 5.0, color: .black)
        deleteAccountButton.addBorder(width: 1.0, radius: 5.0, color: .black)
    }
    
    func showAlertForDeleteAccount() {
        currentUserDocumentID = studyUser.documentID
        
        let alertController = UIAlertController(title: "Are You Sure You Want To Delete Your Account?", message: "Press 'Delete' to delete account and all of your saved data.", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            print("Document to delete isssss... \(self.currentUserDocumentID).")
            self.courses.loadData(currentDocumentID: self.currentUserDocumentID) { success in
                if success {
                    print("This user is taking \(self.courses.courseArray.count) courses.")
                    if self.courses.courseArray.count >= 1 {
                        for course in 0...self.courses.courseArray.count-1 {
                            let course = self.courses.courseArray[course]
                            let currentCourseID = course.documentUUID
                            self.courses.deleteCourse(currentCourseID: currentCourseID) { success in
                                if success {
                                    self.exams.loadData(currentDocumentID: self.currentUserDocumentID, currentCourseID: course.courseID) { success in
                                        if success {
                                            print("This user inputted \(self.exams.examArray.count) exams.")
                                            if self.exams.examArray.count != 0 {
                                                for exam in 0...self.exams.examArray.count-1 {
                                                    let exam = self.exams.examArray[exam]
                                                    self.examDocumentID = exam.examID
                                                }
                                                self.courses.deleteExamsForCourse(currentCourseCourseID: course.courseID, examDocumentID: self.examDocumentID) { success in
                                                    if success {
                                                        return
                                                    } else {
                                                         print("Couldn't delete exams for this course.")
                                                    }
                                                }
                                            } else {
                                                print("There are no exams inputted for this course.")
                                                return
                                            }
                                        } else {
                                            print("Couldn't load exams data.")
                                        }
                                    }
                                } else {
                                    print("Couldn't delete course.")
                                }
                            }
                            return
                        }
                    } else {
                        self.studyUsers.deleteStudyUser(userID: self.currentUserDocumentID) { success in
                            if success {
                                print("successfully deleted study user \(self.currentUserDocumentID).")
                                self.currentUserDocumentID = ""
                                self.performSegue(withIdentifier: "AccountDeleted", sender: nil)
                            } else {
                                print("didn't successfully delete study user \(self.currentUserDocumentID).")
                            }
                        }
                    }
                } else {
                    print("Couldn't load courses data for deleting account.")
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            print("User didn't want to delete his/her account.")
        }))

        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertForResetCourses() {
        currentUserDocumentID = studyUser.documentID
        
        let alertController = UIAlertController(title: "Are You Sure You Want To Delete Your Courses?", message: "Press 'Delete' to delete courses and all of your saved courses data.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            print("Study user wants to delete his/her courses.")
            self.courses.loadData(currentDocumentID: self.currentUserDocumentID) { success in
                if success {
                    print("This user is taking \(self.courses.courseArray.count) courses.")
                    if self.courses.courseArray.count >= 1 {
                        for course in 0...self.courses.courseArray.count-1 {
                            let course = self.courses.courseArray[course]
                            let currentCourseID = course.documentUUID
                            self.courses.deleteCourse(currentCourseID: currentCourseID) { success in
                                if success {
                                    self.exams.loadData(currentDocumentID: self.currentUserDocumentID, currentCourseID: course.courseID) { success in
                                        if success {
                                            print("This user inputted \(self.exams.examArray.count) exams.")
                                            if self.exams.examArray.count != 0 {
                                                for exam in 0...self.exams.examArray.count-1 {
                                                    let exam = self.exams.examArray[exam]
                                                    self.examDocumentID = exam.examID
                                                }
                                                self.courses.deleteExamsForCourse(currentCourseCourseID: course.courseID, examDocumentID: self.examDocumentID) { success in
                                                    if success {
                                                        return
                                                    } else {
                                                        print("Couldn't delete exams for this course.")
                                                    }
                                                }
                                            } else {
                                                print("There are no exams inputted for this course.")
                                                return
                                            }
                                        } else {
                                            print("Couldn't load exams data.")
                                        }
                                    }
                                } else {
                                    print("Couldn't delete course.")
                                }
                            }
                            return
                        }
                    } else {
                        self.performSegue(withIdentifier: "AccountDeleted", sender: nil)
                    }
                } else {
                    print("Couldn't load courses data for deleting courses.")
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            print("User didn't want to delete his/her courses.")
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertForChangePhoneNumber() {
        currentUserDocumentID = studyUser.documentID
        
        let alertController = UIAlertController(title: "Are You Sure You Want To Change Your Phone Number?", message: "Press 'Change' to change your saved phone number.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Change", style: .default, handler: { _ in
            print("Study user wants to change his/her phone number.")
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            print("User didn't want to change his/her phone number.")
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func deleteAccountButtonPressed(_ sender: UIButton) {
        showAlertForDeleteAccount()
    }
    
    @IBAction func resetCoursesButtonPressed(_ sender: UIButton) {
        showAlertForResetCourses()
    }
    
    @IBAction func changePhoneNumberButtonPressed(_ sender: UIButton) {
        showAlertForChangePhoneNumber()
    }
}
