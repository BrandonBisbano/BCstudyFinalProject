//
//  UserSettingsViewController.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 5/1/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {

    var studyUsers: StudyUsers!
    var studyUser: StudyUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
