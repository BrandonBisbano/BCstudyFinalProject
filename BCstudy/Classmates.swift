//
//  StudentsInMyClass.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/27/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import Foundation
import Firebase

class Classmates {
    var classmatesArray = [Classmate]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadClassmatesForTable(currentDocumentID: String, courseReferenceID: String, currentUserEmail: String, completed: @escaping (Bool) -> ()) {
        print("Starting to load students in this course!")
        let db = Firestore.firestore()
        print("CurrentDocumentID for creating classmatesArray: \(currentDocumentID), currentCourseDocumentID for creating classmatesArray: \(courseReferenceID)")
        db.collection("classes").document(courseReferenceID).collection("classmates").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription).")
                return completed(true)
            }
            self.classmatesArray = []
        
            for document in querySnapshot!.documents {
                print("CurrentDocumentID for creating classmatesArray: \(currentDocumentID), currentCourseDocumentID for creating classmatesArray: \(courseReferenceID)")
                let classmate = Classmate(dictionary: document.data())
                if classmate.studentEmail != currentUserEmail {
                    self.classmatesArray.append(classmate)
                }
            }
            print("There are \(self.classmatesArray.count) students in class \(courseReferenceID).")
        
            completed(true)
        }
    }
    
    func loadClassmatesData(currentDocumentID: String, courseReferenceID: String, completed: @escaping (Bool) -> ()) {
        print("Starting to load students in this course!")
        let db = Firestore.firestore()
        print("CurrentDocumentID for creating classmatesArray: \(currentDocumentID), currentCourseDocumentID for creating classmatesArray: \(courseReferenceID)")
        db.collection("classes").document(courseReferenceID).collection("classmates").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription).")
                return completed(true)
            }
            self.classmatesArray = []
            
            for document in querySnapshot!.documents {
                print("CurrentDocumentID for creating classmatesArray: \(currentDocumentID), currentCourseDocumentID for creating classmatesArray: \(courseReferenceID)")
                let classmate = Classmate(dictionary: document.data())
                self.classmatesArray.append(classmate)
            }
            print("There are \(self.classmatesArray.count) students in class \(courseReferenceID).")
            
            completed(true)
        }
    }
}
