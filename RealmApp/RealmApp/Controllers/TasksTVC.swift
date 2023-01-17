//
//  TasksTVC.swift
//  RealmApp
//
//  Created by comp on 15.01.23.
//

import RealmSwift
import UIKit

enum TasksTVCFlow {
    case addingNewTask
    case editingTask(task: Task)
}

struct TxtAlertData {
    // MARK: Lifecycle

    init(tasksTVCFlow: TasksTVCFlow) {
        switch tasksTVCFlow {
            case .addingNewTask:
                messageForAlert = "Please insert new task value"
                doneButtonForAlert = "Save"
            case .editingTask(let task):
                messageForAlert = "Please edit your task"
                doneButtonForAlert = "Update"
                taskName = task.name
                taskNote = task.note
        }
    }

    // MARK: Internal

    let titleForAlert = "Task value"
    var messageForAlert: String
    let doneButtonForAlert: String
    let cancelTxt = "Cancel"
    
    let newTextFieldPlaceholder = "New task"
    let noteTextFieldPlaceholder = "Note"
    
    var taskName: String?
    var taskNote: String?
}

class TasksTVC: UITableViewController {

    var currentTasksList: TasksList?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTasksList?.name
        filteringTasks()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? completedTasks.count : notCompletedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Completed tasks" : "Not completed tasks"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = indexPath.section == 0 ? completedTasks[indexPath.row] : notCompletedTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? completedTasks[indexPath.row] : notCompletedTasks[indexPath.row]
        
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteTask(task)
            self.filteringTasks()
        }
        
        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            self.alertForAddAndUpdateList(tasksTVCFlow: .editingTask(task: task))
        }
        
        let doneText = task.isComplete ? "Not done" : "Done"
        let doneContextItem = UIContextualAction(style: .destructive, title: doneText) { _, _, _ in
            StorageManager.makeDone(task)
            self.filteringTasks()
        }
        
        editContextItem.backgroundColor = .systemBlue
        doneContextItem.backgroundColor = .systemGreen
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])
        
        return swipeActions
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
          return true
      }
     
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let completedTasks = completedTasks,
              var completedTasksArray = Array(completedTasks) as? [Task],
              let notCompletedTasks = notCompletedTasks,
              var notCompletedTasksArray = Array(notCompletedTasks) as? [Task]
        else { return }
        
        if destinationIndexPath.section != sourceIndexPath.section && destinationIndexPath.section == 0 {
           
            let notCompletedTask = notCompletedTasksArray.remove(at: sourceIndexPath.row)
            
            completedTasksArray.insert(notCompletedTask, at: destinationIndexPath.row)
            
            StorageManager.saveMoveTask(notCompletedTask)
        
        } else if destinationIndexPath.section != sourceIndexPath.section && destinationIndexPath.section == 1 {
            
            let completedTask = completedTasksArray.remove(at: sourceIndexPath.row)
            
            notCompletedTasksArray.insert(completedTask, at: destinationIndexPath.row)
            StorageManager.saveMoveTask(completedTask)
        }
    }

    // MARK: Private

    private var notCompletedTasks: Results<Task>!
    private var completedTasks: Results<Task>!

    private func filteringTasks() {
        notCompletedTasks = currentTasksList?.tasks.filter("isComplete = false")
        completedTasks = currentTasksList?.tasks.filter("isComplete = true")
        tableView.reloadData()
    }
}

// MARK: - Adding And Updating List

extension TasksTVC {
    @objc private func addBarButtonSystemItemSelector() {
        alertForAddAndUpdateList(tasksTVCFlow: .addingNewTask)
    }
    
    private func alertForAddAndUpdateList(tasksTVCFlow: TasksTVCFlow) {
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

        let saveAction = UIAlertAction(title: txtAlertData.doneButtonForAlert,
                                       style: .default) { [weak self] _ in

            guard let newNameTask = taskTextField.text, !newNameTask.isEmpty,
                  let newNote = noteTextField.text, !newNote.isEmpty,
                  let self = self else { return }

            switch tasksTVCFlow {
                case .addingNewTask:
                    let task = Task()
                    task.name = newNameTask
                    task.note = newNote
                    guard let currentTasksList = self.currentTasksList else { return }
                    StorageManager.saveTask(currentTasksList, task: task)
                case .editingTask(let task):
                    StorageManager.editTask(task,
                                            newNameTask: newNameTask,
                                            newNote: newNote)
            }
            self.filteringTasks()
        }

        let cancelAction = UIAlertAction(title: txtAlertData.cancelTxt, style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
