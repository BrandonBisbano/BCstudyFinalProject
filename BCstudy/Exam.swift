//
//  Exam.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/26/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import Foundation
import Firebase

class Exam {
    var examDate: TimeInterval
    var examDescription: String
    var examLocation: String
    var examID: String
    
    var dictionary: [String: Any] {
        return ["examDate": examDate, "examDescription": examDescription, "examLocation": examLocation, "examID": examID]
    }
    
    init(examDate: TimeInterval, examDescription: String, examLocation: String, examID: String) {
        self.examDate = examDate
        self.examDescription = examDescription
        self.examLocation = examLocation
        self.examID = examID
    }
    
    convenience init() {
        self.init(examDate: 0.0, examDescription: "", examLocation: "", examID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let examDate = dictionary["examDate"] as! TimeInterval? ?? TimeInterval()
        let examDescription = dictionary["examDescription"] as! String? ?? ""
        let examLocation = dictionary["examLocation"] as! String? ?? ""
        self.init(examDate: examDate, examDescription: examDescription, examLocation: examLocation, examID: "")
    }
    
    func saveExamData(currentDocumentID: String, courseIDForSaving: String, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let userUID = (Auth.auth().currentUser?.uid) else { // do you have a current user? if you do, let's get the userID.
            print("*** ERROR: Could not save data because we don't have a valid userUID.")
            return completed(false)
        }
        let dataToSave = self.dictionary
        
        var ref: DocumentReference? = nil // Firestore will creat a new ID for us
        ref = db.collection("users").document(currentDocumentID).collection("courses").document(courseIDForSaving).collection("exams").addDocument(data: dataToSave) { (error) in
            if let error = error {
                print("ERROR: creating new document \(self.examID) \(error.localizedDescription)")
                completed(false)
            } else { // It worked! Save the documentID in Spot’s documentID property
                self.examID = ref!.documentID
                print("^^^ New document created with ref ID \(ref?.documentID ?? "unknown").")
                completed(true)
            }
        }
    }
}
