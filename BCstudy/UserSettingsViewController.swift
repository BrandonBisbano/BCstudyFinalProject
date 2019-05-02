//
//  UserSettingsViewController.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 5/1/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {

    @IBOutlet weak var changePhoneNumberButton: UIButton!
    @IBOutlet weak var changeEmailAddressButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    var studyUsers: StudyUsers!
    var studyUser: StudyUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBordersToButtons()
    }
    
    func addBordersToButtons() {
        changePhoneNumberButton.addBorder(width: 1.0, radius: 5.0, color: .black)
        changeEmailAddressButton.addBorder(width: 1.0, radius: 5.0, color: .black)
        deleteAccountButton.addBorder(width: 1.0, radius: 5.0, color: .black)
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
