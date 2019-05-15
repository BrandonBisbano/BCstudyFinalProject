//
//  MyCoursesTableViewCell.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/26/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit

class MyCoursesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var examTimeLabel: UILabel!
    @IBOutlet weak var examLocationLabel: UILabel!
    @IBOutlet weak var examDescriptionLabel: UILabel!

    var exam: Exam!
    
    func configureExamCell(exam: Exam) {
        print("Configuring exam table view cell!")
        let timeIntervalDate = exam.examDate
        let dateNSDate = NSDate(timeIntervalSince1970: timeIntervalDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"
        let formattedDate = dateFormatter.string(from: dateNSDate as Date)
        
        examTimeLabel.text = " \(formattedDate)"
        examLocationLabel.text = " \(exam.examLocation)"
        examDescriptionLabel.text = " \(exam.examDescription)"
    }
}
