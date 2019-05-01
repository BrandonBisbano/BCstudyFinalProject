//
//  MyCoursesTableViewViewController.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/19/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class MyCoursesTableViewController: UIViewController {

    @IBOutlet weak var myCoursesTableView: UITableView!
    @IBOutlet weak var addCourseButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    var authUI: FUIAuth!
    var studyUser: StudyUser!
    var studyUsers: StudyUsers!
    var exams: Exams!
    var courses: Courses!
    var currentUserDocumentID: String!
    var examDocumentID: String!
    var currentUserEmail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad on main view controller!")
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self

        myCoursesTableView.delegate = self
        myCoursesTableView.dataSource = self
        myCoursesTableView.isHidden = true
        
        courses = Courses()
        studyUsers = StudyUsers()
        exams = Exams()
        
        signIn()
        
        print("ViewDidLoad completed!!!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear on main view controller!")
        if currentUserDocumentID == nil {
            print("currentUserDocumentID was equal to nil :( Trying to sign in.")
            self.myCoursesTableView.isHidden = true
            signIn()
        } else {
            courses.loadData(currentDocumentID: studyUser.documentID) { (success) in
                if success {
                    self.myCoursesTableView.reloadData()
                    self.myCoursesTableView.isHidden = false
                } else {
                    print("Couldn't load courses data in view will appear on main page.")
                }
            }
            studyUsers.loadData { success in
                if success {
                    print("Loaded studyUsers data in view will appear on main page!")
                } else {
                    print("Couldn't load studyUsers data in view will appear on main page :(")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidAppear on main view controller!")
        print("currentUserDocumentID: \(currentUserDocumentID)")
        let currentUser = authUI.auth?.currentUser
        if currentUserDocumentID != currentUser?.uid {
            studyUser = StudyUser(user: currentUser!)
            courses.loadData(currentDocumentID: studyUser.documentID) { (success) in
                if success {
                    print("Data successfully loaded off of firebase.")
                    print("Data reloaded in the table view.")
                    print("Phone number for this study user is \(self.studyUser.phoneNumber).")
                    self.myCoursesTableView.reloadData()
                } else {
                    print("Couldn't load data off firebase in main view controller.")
                }
            }
        } else {
            print("ViewDidAppearFinished")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCourse" {
            let destination = segue.destination.children[0] as! AddCourseViewController
            currentUserDocumentID = studyUser.documentID
            let currentDocumentID = currentUserDocumentID
            destination.currentDocumentID = currentDocumentID
            destination.currentUser = studyUser
            print("Prepared for segue AddCourse")
        } else if segue.identifier == "ShowCourseDetail" {
            let destination = segue.destination.children[0] as! CourseDetailViewController
            let selectedIndexPath = myCoursesTableView.indexPathForSelectedRow!
            destination.course = courses.courseArray[selectedIndexPath.row]
            destination.userDocumentID = studyUser.documentID
            destination.studyUsers = studyUsers
            let currentUser = authUI.auth?.currentUser
            destination.currentUserEmail = currentUser!.email!
            print("Prepared for segue ShowCourseDetail")
        }
    }
    
    func signIn() {
        print("signIn() is officially beginning to execute.")
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        let currentUser = authUI.auth?.currentUser
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            print("Going to present authViewController()")
            present(authUI.authViewController(), animated: true, completion: nil)
            print("authViewController() presented...")
        } else {
            studyUser = StudyUser(user: currentUser!)
            
            studyUser.saveIfNewUser()
            currentUserDocumentID = studyUser.documentID
            print("Phone number for this study user is \(self.studyUser.phoneNumber).")
            print("currentUserDocumentID = \(currentUserDocumentID)")
            print("SignIn() function executed on main view controller, and the currentUserDocumentID has been updated.")
            myCoursesTableView.isHidden = false
        }
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            myCoursesTableView.isHidden = true
            signIn()
        } catch {
            myCoursesTableView.isHidden = true
            print("*** Error: Couldn't sign out.")
        }
    }
    
    @IBAction func editCoursesPressed(_ sender: UIBarButtonItem) {
        if myCoursesTableView.isEditing {
            myCoursesTableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addCourseButton.isEnabled = true
        } else {
            myCoursesTableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addCourseButton.isEnabled = false
        }
    }
}

extension MyCoursesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.courseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCourseCell", for: indexPath) as! MyCourseTableViewCell
        cell.course = courses.courseArray[indexPath.row]
        cell.configureCourseCell(course: cell.course)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("There are initially \(courses.courseArray.count) courses.")
            let selectedIndexPath = courses.courseArray[indexPath.row]
            let currentCourseDocumentID = selectedIndexPath.documentUUID
            courses.courseArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            courses.deleteCourse(currentCourseID: currentCourseDocumentID) { (success) in
                if success {
                    self.exams.loadData(currentDocumentID: self.currentUserDocumentID, currentCourseID: selectedIndexPath.courseID) { (success) in
                        if success {
                            print("This user inputted \(self.exams.examArray.count) exams.")
                            if self.exams.examArray.count != 0 {
                                for exam in 0...self.exams.examArray.count-1 {
                                    let exam = self.exams.examArray[exam]
                                    self.examDocumentID = exam.examID
                                }
                                self.courses.deleteExamsForCourse(currentCourseCourseID: selectedIndexPath.courseID, examDocumentID: self.examDocumentID) { (success) in
                                    if success {
                                        print("After deleting the course and the exams, there are \(self.courses.courseArray.count) courses.")
                                        self.courses.loadData(currentDocumentID: self.currentUserDocumentID) { (success) in
                                            if success {
                                                self.myCoursesTableView.reloadData()
                                                print("Successfully loaded new course data!")
                                            } else {
                                                print("ERROR LOADING TABLE VIEW AFTER DELETING DATA.")
                                            }
                                        }
                                    } else {
                                        print("Error deleting exams for course \(selectedIndexPath.courseID)")
                                    }
                                }
                            } else {
                                self.courses.loadData(currentDocumentID: self.currentUserDocumentID) { (success) in
                                    if success {
                                        self.myCoursesTableView.reloadData()
                                        print("Successfully loaded new course data!")
                                    } else {
                                        print("ERROR LOADING TABLE VIEW AFTER DELETING DATA.")
                                    }
                                }
                            }
                        } else {
                            print("Failed to do something")
                        }
                    }
                } else {
                    print("Error deleting course \(currentCourseDocumentID)")
                }
            }
        }
    }
}

extension MyCoursesTableViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
        
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            // Assumes data will be isplayed in a tableView that was hidden until login was verified so unauthorized users can't see data.
            print("^^^ We signed in with the user \(user.email ?? "unknown e-mail") and his/her currentDocumentID is \(user.uid)")
            let currentUser = authUI.auth?.currentUser
            print("PHONE NUMBER: \(user.phoneNumber)")
            print("Phone number for user \(currentUser?.displayName) is \(currentUser?.phoneNumber).")
            courses.loadData(currentDocumentID: (currentUser?.uid)!) { (success) in
                if success {
                    print("Data successfully loaded off of firebase in the extension.")
                    print("Data reloaded in the table view in the extension.")
                    self.myCoursesTableView.reloadData()
                    self.myCoursesTableView.isHidden = false
                } else {
                    print("Error loading courses data for the current user in the authUI extension.")
                }
            }
        }
    }
        
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
            
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
            
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
            
        // Create a frame for a UIImageView to hold our logo
        let marginInsets: CGFloat = 16 // logo will be 16 points from L and R margins
        let imageHeight: CGFloat = 225 // the height of our logo
        let imageY = self.view.center.y - imageHeight // places bottom of UIImageView in the center of the login screen
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
            
        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
}



