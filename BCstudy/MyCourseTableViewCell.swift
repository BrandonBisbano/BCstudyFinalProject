//
//  MyCoursesTableViewCell.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/26/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import UIKit

class MyCourseTableViewCell: UITableViewCell {

    @IBOutlet weak var myCourseNameLabel: UILabel!
    @IBOutlet weak var myCourseProfessorNameLabel: UILabel!
    @IBOutlet weak var myCourseExamOnLabel: UILabel!
    
    var course: Course!
    
    func configureCourseCell(course: Course) {
        print("Configuring table view cell!")
        myCourseNameLabel.text = " \(course.courseName)"
        myCourseProfessorNameLabel.text = " \(course.professorName)"
        myCourseExamOnLabel.text = " \(course.courseID)"
    }
}
