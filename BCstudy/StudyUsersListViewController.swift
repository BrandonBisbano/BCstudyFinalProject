//
//  StudyUsersListViewController.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/24/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit

class StudyUsersListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var studyUsers: StudyUsers!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        studyUsers = StudyUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        studyUsers.loadData { success in
            if success {
                self.tableView.reloadData()
            } else {
                print("Couldn't reload studyUsers table.")
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "LeaveShowUser", sender: nil)
    }
}

extension StudyUsersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studyUsers.studyUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! StudyUsersTableViewCell
        cell.studyUser = studyUsers.studyUserArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
