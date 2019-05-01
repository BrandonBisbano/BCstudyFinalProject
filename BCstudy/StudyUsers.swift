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
}
