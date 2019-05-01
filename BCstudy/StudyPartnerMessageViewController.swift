//
//  StudyPartnerGmailViewController.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/29/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit
import MessageUI

class StudyPartnerMessageViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    var classmate: Classmate!
    var courseNameString: String!
    var currentUserEmail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hey \(classmate.studentName),"
            controller.recipients = [classmate.studentPhoneNumber] // classmate.phoneNumber should import the phone number for this classmate too but can't get that value through google sign in.
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
        
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}


