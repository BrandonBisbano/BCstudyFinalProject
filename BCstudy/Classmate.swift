//
//  StudentInMyClass.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/27/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import Foundation
import Firebase

class Classmate {
    var studentName: String
    var studentEmail: String
    var studentPhoneNumber: String
    var imageURL: String
    var studentUUID: String
    
    var dictionary: [String: Any] {
        return ["studentName": studentName, "studentEmail": studentEmail, "studentPhoneNumber": studentPhoneNumber, "imageURL": imageURL, "studentUUID": studentUUID]
    }
    
    init(studentName: String, studentEmail: String, studentPhoneNumber: String, imageURL: String, studentUUID: String) {
        self.studentName = studentName
        self.studentEmail = studentEmail
        self.studentPhoneNumber = studentPhoneNumber
        self.imageURL = imageURL
        self.studentUUID = studentUUID
    }
 
    convenience init(userID: String) {
        self.init(studentName: "", studentEmail: "", studentPhoneNumber: "", imageURL: "", studentUUID: userID)
    }
    
    convenience init(dictionary: [String: Any]) {
        let studentName = dictionary["studentName"] as! String? ?? ""
        let studentEmail = dictionary["studentEmail"] as! String? ?? ""
        let studentPhoneNumber = dictionary["studentPhoneNumber"] as! String? ?? ""
        let imageURL = dictionary["imageURL"] as! String? ?? ""
        self.init(studentName: studentName, studentEmail: studentEmail, studentPhoneNumber: studentPhoneNumber, imageURL: imageURL, studentUUID: "")
    }
    
    func saveStudentInformation(currentDocumentID: String, courseReferenceID: String, classmate: Classmate, studyUser: StudyUser, completed: @escaping (Bool) -> ()) {
        print("Saving classmate in because he/she has a course with the same courseID as the current user!")
        print("Before saving classmate info, phone number is \(studyUser.phoneNumberString)")
        let db = Firestore.firestore()
        // Grab the user ID
        guard let userUID = (Auth.auth().currentUser?.uid) else { // do you have a current user? if you do, let's get the userID.
            print("*** ERROR: Could not save data because we don't have a valid userUID.")
            return completed(false)
        }
        let dataToSave = self.dictionary
        self.studentPhoneNumber = studyUser.phoneNumberString
        print("After saving classmate info, phone number is \(classmate.studentPhoneNumber).")
        
        var ref: DocumentReference?
        db.collection("classes").document(courseReferenceID).collection("classmates").addDocument(data: dataToSave) { (error) in
            if let error = error {
                print("ERROR: creating new document \(self.studentUUID) \(error.localizedDescription)")
                completed(false)
            } else { // It worked! Save the documentID in Spot’s documentID property
                self.studentUUID = currentDocumentID
                print("self.studentUUID is equal to \(self.studentUUID) when the document is created for the new user.")
                print("^^^ New document created with ref ID \(ref?.documentID ?? "unknown").")
                completed(true)
            }
        }
    }
    
    func deleteData(userDocumentID: String, currentCourseID: String, documentToDeleteID: String, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
    db.collection("users").document(userDocumentID).collection("courses").document(currentCourseID).collection("classmates").document(documentToDeleteID).delete() { error in
            if let error = error {
                print("*** ERROR: Could not delete a document with documentID \(documentToDeleteID) in \(error.localizedDescription).")
                completed(false)
            } else {
                print("Just deleted the user's classmates document.")
                completed(true)
            }
        }
    }
}

