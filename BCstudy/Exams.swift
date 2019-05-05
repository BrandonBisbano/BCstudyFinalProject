//
//  Exams.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/26/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import Foundation
import Firebase

class Exams {
    var examArray = [Exam]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(currentDocumentID: String, currentCourseID: String, completed: @escaping (Bool) -> ()) {
        guard currentDocumentID != "" else {
            return
        }
        db.collection("users").document(currentDocumentID).collection("courses").document(currentCourseID).collection("exams").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: Adding the snapshot listener!!!!.")
                return completed(true)
            }
            print("Data starting to load into table.")
            self.examArray = []
            // There are querySnapshot!.documents.count documents in the spots snapshot.
            for document in querySnapshot!.documents {
                let exam = Exam(dictionary: document.data())
                exam.examID = document.documentID
                self.examArray.append(exam)
            }
            completed(true)
        }
    }
    
    func deleteExam(currentCourseCourseID: String, examDocumentID: String, completed: @escaping (Bool) -> ()) {
        guard let userUID = (Auth.auth().currentUser?.uid) else { // do you have a current user? if you do, let's get the userID.
            print("*** ERROR: Could not delete data because we don't have a valid userUID.")
            return completed(false)
        }
        print("deleting current user's exam \(examDocumentID) for course with id \(currentCourseCourseID).")
        let db = Firestore.firestore()
        db.collection("users").document(userUID).collection("courses").document(currentCourseCourseID).collection("exams").document(examDocumentID).delete() { error in
            if let error = error {
                print("*** ERROR: Could not delete a document with documentID \(currentCourseCourseID) in \(error.localizedDescription).")
                completed(false)
            } else {
                print("Just deleted the user's exam document for the class.")
                completed(true)
            }
        }
    }
}
