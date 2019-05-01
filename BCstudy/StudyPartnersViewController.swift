//
//  StudyPartnersViewController.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/26/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class StudyPartnersViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var studyPartnersTableView: UITableView!
    @IBOutlet weak var composeEmailButton: UIBarButtonItem!
    
    var studentsInClass: [String] = []
    // you may wanna get rid of this later. don't know if you need it
    
    var studyUsers: StudyUsers!
    var courses: Courses!
    var classmate: Classmate!
    var classmates: Classmates!
    var currentUserDocumentID: String!
    var currentCourseDocumentID: String!
    var courseReferenceID: String!
    var currentUserPhoneNumber: String!
    var currentUserEmail: String!
    var courseName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        studyPartnersTableView.delegate = self
        studyPartnersTableView.dataSource = self
        studyPartnersTableView.isHidden = true
        
        classmates = Classmates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("In StudyPartnersViewController in ViewDidAppear before trying to load data, currentUserDocumentID = \(currentUserDocumentID), currentCourseDocumentID = \(currentCourseDocumentID), currentCourseID = \(courseReferenceID).")
        classmates.loadClassmatesForTable(currentDocumentID: currentUserDocumentID, courseReferenceID: courseReferenceID, currentUserEmail: currentUserEmail) { (success) in
            if success {
                print("successfully loaded classmates data in StudyPartnersTableViewController. classmates: \(self.classmates.classmatesArray)")
                self.studyPartnersTableView.reloadData()
                self.studyPartnersTableView.isHidden = false
            } else {
                print("Error loading in classmates data in StudyPartnersTableViewController.")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessageClassmate" {
            let destination = segue.destination.children[0] as! StudyPartnerMessageViewController
            let selectedIndexPath = studyPartnersTableView.indexPathForSelectedRow!
            destination.classmate = classmates.classmatesArray[selectedIndexPath.row]
            destination.courseNameString = courseName
            print("Prepared for segue MessageClassmate")
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("Studying for \(courseName!)")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func messageButtonPressed(_ sender: UIButton) {
        if currentUserPhoneNumber == nil {
            print("There was no phone number to message with!")
        } else {
//            performSegue(withIdentifier: "MessageStudyPartner", sender: nil)
            print("Not up and running yet")
        }
    }
    
    @IBAction func composeEmailButtonPressed(_ sender: UIBarButtonItem) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
}

extension StudyPartnersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classmates.classmatesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyPartnerCell", for: indexPath) as! StudyPartnersTableViewCell
        cell.classmate = classmates.classmatesArray[indexPath.row]
        cell.configureClassmateCell(classmate: cell.classmate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
}
