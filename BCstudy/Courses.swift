//
//  Courses.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/24/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import Foundation
import Firebase

class Courses {
    var courseArray = [Course]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(currentDocumentID: String, completed: @escaping (Bool) -> ()) {
        print("Loading Data: currentDocumentID: \(currentDocumentID)")
        db.collection("users").document(currentDocumentID).collection("courses").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: Adding the snapshot listener!!!!.")
                return completed(true)
            }
            self.courseArray = []
            // There are querySnapshot!.documents.count documents in the spots snapshot.
            for document in querySnapshot!.documents {
                let course = Course(dictionary: document.data())
                course.documentUUID = document.documentID
                self.courseArray.append(course)
            }
            print("Finished loading data for user \(currentDocumentID) in courses.")
            completed(true)
        }
    }
    
    func deleteCourse(currentCourseID: String, completed: @escaping (Bool) -> ()) {
        guard let userUID = (Auth.auth().currentUser?.uid) else { // do you have a current user? if you do, let's get the userID.
            print("*** ERROR: Could not delete data because we don't have a valid userUID.")
            return completed(false)
        }
        let db = Firestore.firestore()
        db.collection("users").document(userUID).collection("courses").document(currentCourseID).delete() { error in
            if let error = error {
                print("*** ERROR: Could not delete a document with documentID \(currentCourseID) in \(error.localizedDescription).")
                completed(false)
            } else {
                print("Just deleted the user's course document.")
                completed(true)
            }
        }
    }
    
    func deleteExamsForCourse(currentCourseCourseID: String, examDocumentID: String, completed: @escaping (Bool) -> ()) {
        guard let userUID = (Auth.auth().currentUser?.uid) else { // do you have a current user? if you do, let's get the userID.
            print("*** ERROR: Could not delete data because we don't have a valid userUID.")
            return completed(false)
        }
        print("deleting current user's exams for course with id \(currentCourseCourseID).")
        let db = Firestore.firestore()
        db.collection("users").document(userUID).collection("courses").document(currentCourseCourseID).collection("exams").document(examDocumentID).delete() { error in
            if let error = error {
                print("*** ERROR: Could not delete a document with documentID \(currentCourseCourseID) in \(error.localizedDescription).")
                completed(false)
            } else {
                print("Just deleted the user's exams document for the class.")
                completed(true)
            }
        }
    }
}
