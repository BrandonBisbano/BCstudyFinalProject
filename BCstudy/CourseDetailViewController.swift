//
//  CourseDetailViewController.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/16/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit
import Firebase

class CourseDetailViewController: UIViewController {

    @IBOutlet weak var myExamsTableView: UITableView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var professorNameLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var findAStudyPartnerButton: UIButton!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addExamButton: UIBarButtonItem!
    
    var course: Course!
    var courses: Courses!
    var exams: Exams!
    var currentUser: StudyUser!
    var studyUser: StudyUser!
    var studyUsers: StudyUsers!
    var classmate: Classmate!
    var classmates: Classmates!
    var userDocumentID: String = ""
    var courseReferenceID: String = ""
    var currentUserEmail: String = ""
    var examReferenceID: String = ""
    var arrayOfClassmates = [Classmate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myExamsTableView.delegate = self
        myExamsTableView.dataSource = self
        myExamsTableView.isHidden = true
        
        addBordersToButtons()
        
        exams = Exams()
        classmates = Classmates()
        
        configureData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
        courseReferenceID = course.courseID
        print("currentDocumentID: \(userDocumentID), currentCourseID: \(courseReferenceID)")
        classmates.loadClassmatesData(currentDocumentID: userDocumentID, courseReferenceID: courseReferenceID) { (success) in
            if success {
                if self.classmates.classmatesArray.count == 1 {
                    self.findAStudyPartnerButton.setTitle("No Classmates", for: .normal)
                    self.findAStudyPartnerButton.isEnabled = false
                } else {
                    self.findAStudyPartnerButton.setTitle("Find a Study Partner", for: .normal)
                    self.findAStudyPartnerButton.isEnabled = true
                }
            } else {
                print("Failed to load classmates data in CourseDetailViewController!.")
            }
        }

        exams.loadData(currentDocumentID: userDocumentID, currentCourseID: courseReferenceID) { (success) in
            if success {
                if self.exams.examArray.count == 0 {
                    self.myExamsTableView.isHidden = true
                    self.editBarButton.isEnabled = false
                } else {
                    print("Data successfully loaded in!!!!")
                    self.editBarButton.isEnabled = true
                    self.myExamsTableView.isHidden = false
                    self.myExamsTableView.reloadData()
                }
            } else {
                print("Failed to load exams data.")
                self.editBarButton.isEnabled = false
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExam" {
            let destination = segue.destination.children[0] as! AddExamViewController
            destination.userDocumentID = userDocumentID
            destination.courseDocumentID = course.courseID
            print("Prepared for segue AddExam")
        } else if segue.identifier == "ShowClassmateList" {
            print("userDocumentID: \(userDocumentID)")
            print("course.documentUUID: \(course.documentUUID)")
            let destination = segue.destination.children[0] as! StudyPartnersViewController
        
            let currentUserEmail = self.currentUserEmail
            
            destination.courseName = course.courseName
            destination.currentUserDocumentID = self.userDocumentID
            destination.currentCourseDocumentID = self.course.documentUUID
            destination.courseReferenceID = self.courseReferenceID
            destination.currentUserEmail = currentUserEmail
            
            print("Prepared for segue ShowCourseStudents")

        }
    }
    
    func addBordersToButtons() {
        findAStudyPartnerButton.addBorder(width: 1.0, radius: 5.0, color: .black)
    }
    
    func configureData() {
        courseNameLabel.text = " \(course.courseName)"
        professorNameLabel.text = " \(course.professorName)"
        sectionLabel.text = " \(course.courseID)"
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addExamButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if myExamsTableView.isEditing {
            myExamsTableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addExamButton.isEnabled = true
        } else {
            myExamsTableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addExamButton.isEnabled = false
        }
    }
    
    @IBAction func findAStudyPartnerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowClassmateList", sender: nil)
    }
}

extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exams.examArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExamCell", for: indexPath) as! MyCoursesTableViewCell
        cell.configureExamCell(exam: exams.examArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("There are initially \(exams.examArray.count) courses.")
            let selectedIndexPath = exams.examArray[indexPath.row]
            let currentCourseDocumentID = selectedIndexPath.examID
            exams.examArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.exams.loadData(currentDocumentID: self.userDocumentID, currentCourseID: self.courseReferenceID) { (success) in
                if success {
                    print("This user inputted \(self.exams.examArray.count) exams.")
                    if self.exams.examArray.count != 0 {
                        self.exams.deleteExam(currentCourseCourseID: self.courseReferenceID, examDocumentID: selectedIndexPath.examID) { (success) in
                            if success {
                                self.exams.loadData(currentDocumentID: self.userDocumentID, currentCourseID: self.courseReferenceID) { (success) in
                                    if success {
                                        self.myExamsTableView.reloadData()
                                            print("Successfully loaded new course data!")
                                    } else {
                                        print("Failed to do something")
                                    }
                                }
                            } else {
                                print("Failed to do something")
                            }
                        }
                    } else {
                        print("Failed to do something")
                        self.myExamsTableView.isHidden = true
                    }
                } else {
                    print("Error deleting course \(currentCourseDocumentID)")
                }
            }
        }
    }
}
