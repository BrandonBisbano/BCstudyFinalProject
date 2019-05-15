//
//  StudyUsersTableViewCell.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/24/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

class StudyUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    var studyUser: StudyUser! {
        didSet {
            displayNameLabel.text = " \(studyUser.displayName)"
            emailLabel.text = " \(studyUser.email)"
            if studyUser.photoURL != "" {
                let url = URL(string: studyUser.photoURL)
                let imageUrl = NSData(contentsOf: url!)
                photoImage.image = UIImage(data: imageUrl! as Data)
            } else {
                photoImage.image = UIImage(named: "eagle")
            }
        }
    }
}
