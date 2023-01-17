//
//  UIAlertControllerExt.swift
//  RealmApp
//
//  Created by comp on 15.01.23.
//

import UIKit

extension UIAlertController {
    
    static func showAlertWithTwoTF(tasksTVCFlow: TasksTVCFlow,
                                   okAction: (TasksTVCFlow) -> (),
                                   cancelAction: () -> ()) {
        
        let txtAlertData = TxtAlertData(tasksTVCFlow: tasksTVCFlow)

        let alert = UIAlertController(title: txtAlertData.titleForAlert,
                                      message: txtAlertData.messageForAlert,
                                      preferredStyle: .alert)

        var taskTextField: UITextField!
        var noteTextField: UITextField!

        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = txtAlertData.newTextFieldPlaceholder
            taskTextField.text = txtAlertData.taskName
        }

        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = txtAlertData.noteTextFieldPlaceholder
            noteTextField.text = txtAlertData.taskNote
        }
    }
}
