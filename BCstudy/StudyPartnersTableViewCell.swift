//
//  StudyPartnersTableViewCell.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/27/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit

class StudyPartnersTableViewCell: UITableViewCell {

    @IBOutlet weak var classmateName: UILabel!
    @IBOutlet weak var classmateEmailLabel: UILabel!
    @IBOutlet weak var classmateImage: UIImageView!
    
    var classmate: Classmate!
    
    func configureClassmateCell(classmate: Classmate) {
        classmateName.text = " \(classmate.studentName)"
        classmateEmailLabel.text = " \(classmate.studentEmail)"
        if classmate.imageURL != "" {
            let url = URL(string: classmate.imageURL)
            let imageUrl = NSData(contentsOf: url!)
            classmateImage.image = UIImage(data: imageUrl! as Data)
        } else {
            classmateImage.image = UIImage(named: "eagle")
        }
    }

}
