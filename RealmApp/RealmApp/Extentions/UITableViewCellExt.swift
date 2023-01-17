//
//  UITableViewCell.swift
//  RealmApp
//
//  Created by comp on 15.01.23.
//

import UIKit

extension UITableViewCell {
    func configure(with tasksList: TasksList) {
        let notCompletedTasks = tasksList.tasks.filter("isComplete = false")
        let completedTasks = tasksList.tasks.filter("isComplete = true")

        textLabel?.text = tasksList.name

        if !notCompletedTasks.isEmpty {
            detailTextLabel?.text = "\(notCompletedTasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .red
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = "✓"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            detailTextLabel?.textColor = .green
        } else {
            detailTextLabel?.text = "0"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            detailTextLabel?.textColor = .black
        }
    }
}
