//
//  PhoneVerificationViewController.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 5/1/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit

class PhoneVerificationViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var savePhoneNumberButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var studyUser: StudyUser!
    var charactersInField: Int!
    var userPhoneNumber: String!
    var doWeHaveUserPhoneVerification: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneNumberTextField.isEnabled = true
        savePhoneNumberButton.isEnabled = true
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCoursesTable" {
            let navigationController = segue.destination as! UINavigationController
            let myCoursesTableViewController = navigationController.viewControllers.first as! MyCoursesTableViewController
            myCoursesTableViewController.studyUser = studyUser
            myCoursesTableViewController.doWeHaveUserPhoneVerification = doWeHaveUserPhoneVerification
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func savePhoneNumberButtonPressed(_ sender: UIButton) {
        if phoneNumberTextField.text!.count == 11 {
            studyUser.phoneNumberString = phoneNumberTextField.text!
            doWeHaveUserPhoneVerification = true
            studyUser.saveIfNewUser()
            print("Phone number for this study user in PhoneVerificationViewController is \(self.studyUser.phoneNumberString).")
            print("New study user \(studyUser.displayName) saved, along with their phone number.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                self.performSegue(withIdentifier: "ToCoursesTable", sender: nil)
            }
        } else {
            self.showAlert(title: "Please Enter Valid Number", message: "Your phone number should include an area code.")
        }
    }
}

extension PhoneVerificationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
}
