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
        
        phoneNumberTextField.delegate = self
        phoneNumberTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        
        addBordersToButtons()
        addBordersToLabelsAndTextFields()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAlert(title: "This App Requires Your Phone Number", message: "To use messaging services within the app, please input your phone number.")
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
    
    func addBordersToButtons() {
        savePhoneNumberButton.addBorder(width: 1.0, radius: 5.0, color: .black)
    }
    
    func addBordersToLabelsAndTextFields() {
        phoneNumberTextField.addBorder(width: 1.0, radius: 5.0, color: .gray)
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
        if phoneNumberTextField.text!.count == 17 {
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
    
    @IBAction func phoneNumberTextFieldEditingChanged(_ sender: UITextField) {
        if phoneNumberTextField.text! != "" {
            let currentText = phoneNumberTextField.text!
            phoneNumberTextField.text = currentText.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacmentCharacter: "#")
        }
    }
}

extension PhoneVerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 17
    }
}

extension String {
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
