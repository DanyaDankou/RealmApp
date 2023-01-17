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

        /// UITextField-s
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
//
//        /// Action-s
//
//        let saveAction = UIAlertAction(title: txtAlertData.doneButtonForAlert,
//                                       style: .default) { [weak self] _ in
//
//            guard let newNameTask = taskTextField.text, !newNameTask.isEmpty,
//                  let newNote = noteTextField.text, !newNote.isEmpty,
//                  let self = self else { return }
//
//            switch tasksTVCFlow {
//                case .addingNewTask:
//                    let task = Task()
//                    task.name = newNameTask
//                    task.note = newNote
//                    guard let currentTasksList = self.currentTasksList else { return }
//                    StorageManager.saveTask(currentTasksList, task: task)
//                case .editingTask(let task):
//                    StorageManager.editTask(task,
//                                            newNameTask: newNameTask,
//                                            newNote: newNote)
//            }
//            self.filteringTasks()
//        }
//
//        let cancelAction = UIAlertAction(title: txtAlertData.cancelTxt, style: .destructive)
//
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true)
    }
}
