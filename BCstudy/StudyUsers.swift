//
//  StudyUsers.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/24/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import Foundation
import Firebase

class StudyUsers {
    var studyUserArray = [StudyUser]()
    var db: Firestore!
    var studyUser: StudyUser!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping (Bool) -> ()) {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription).")
                return completed(true)
            }
            self.studyUserArray = []

            for document in querySnapshot!.documents {
                let studyUser = StudyUser(dictionary: document.data())
                studyUser.documentID = document.documentID
                self.studyUserArray.append(studyUser)
            }
            completed(true)
        }
    }
    
    func loadUserDataForCalculation(currentUserDocumentID: String, completed: @escaping () -> ()) {
        db.collection("users").document(currentUserDocumentID).collection("courses").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription).")
                return completed()
            }
            self.studyUserArray = []
            
            for document in querySnapshot!.documents {
                let studyUser = StudyUser(dictionary: document.data())
                studyUser.documentID = document.documentID
                self.studyUserArray.append(studyUser)
            }
            completed()
        }
    }
    
    func deleteStudyUser(userID: String, completed: @escaping (Bool) -> ()) {
        guard let userUID = (Auth.auth().currentUser?.uid) else { // do you have a current user? if you do, let's get the userID.
            print("*** ERROR: Could not delete data because we don't have a valid userUID.")
            return completed(false)
        }
        let db = Firestore.firestore()
        db.collection("users").document(userID).delete { error in
            if let error = error {
                print("*** ERROR: Could not delete a document with documentID \(userID) in \(error.localizedDescription).")
                completed(false)
            } else {
                print("Just deleted the user's course document.")
                completed(true)
            }
        }
    }
}
