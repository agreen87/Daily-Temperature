//
//  TemperatureViewController.swift
//  tempTest
//
//  Created by Amanda Green on 8/17/20.
//  Copyright © 2020 Amanda Green. All rights reserved.
//

import UIKit
import CoreData

class TemperatureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameDisplay: UILabel!
    
    var temps:[Temperature]?
    var myStudent: String = ""
    var displayTemp:String = ""
    var tempLogged:String = ""
    var myTime:String = ""
    var myDate:String = ""
    var studentTemp:Double = 0.0
    
    var students: Child?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        nameDisplay.layer.borderColor = UIColor.lightGray.cgColor
        nameDisplay.layer.borderWidth = 1.0;
        nameDisplay.text! = students?.name ?? " "
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.temperatures?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tempCell", for: indexPath)
        if let selectedStudent = students?.temperatures?[indexPath.row] {
            
            studentTemp = (selectedStudent.degrees! as NSString).doubleValue
            
            if (studentTemp < 100.4 ) {
                cell.textLabel?.text = String(studentTemp) + " °F"
                cell.detailTextLabel?.text = selectedStudent.dateAndTime
            } else {
                cell.textLabel?.text = String(studentTemp) + " °F  🌡️ Sent home"
                cell.detailTextLabel?.text = selectedStudent.dateAndTime!
            }
            
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            self.deleteTempeture(at: indexPath)
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            
            
            let tempToEdit = self.students?.temperatures?[indexPath.row]
            
            let alert = UIAlertController(title: "Edit Temp", message: "Edit temperature:", preferredStyle: .alert)
            
            alert.addTextField()
            
            let textField = alert.textFields![0]
            textField.text = tempToEdit!.degrees
            textField.keyboardType = .decimalPad
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
                
                let textField = alert.textFields![0]
                let currentDateTime = Date()
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                formatter.dateStyle = .medium
                
                let dateTime = formatter.string(from: currentDateTime)
                self.tempLogged = dateTime
                
                tempToEdit?.degrees = textField.text
                tempToEdit?.dateAndTime = "Edited: " + self.tempLogged
                
                do {
                    try self.context.save()
                    tableView.reloadData()
                } catch {
                    
                }
            }
            
            alert.addAction(cancelButton)
            alert.addAction(saveButton)
            self.present(alert, animated: true, completion: nil)
        }
        return UISwipeActionsConfiguration(actions: [action, edit])
    }
    
    @IBAction func addTemperature(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add temperature.", message: "Enter a student's temperature.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Student Temperature"
            textField.keyboardType = .decimalPad
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        let submitButton = UIAlertAction(title: "Add", style: .default) {(action) in
            
            let textField = alert.textFields![0]
            
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .medium
            
            let dateTime = formatter.string(from: currentDateTime)
            self.tempLogged = dateTime
            
            if let newTemp = Temperature(degrees: textField.text!, dateAndTime: self.tempLogged) {
                self.students?.addToStudent(newTemp)
                
                do {
                    try newTemp.managedObjectContext?.save()
                    self.tableView.reloadData()
                } catch {
                    print("ERROR")
                }
            }
        }
        
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteTempeture(at indexPath: IndexPath) {
        guard let tempToRemove = self.students?.temperatures?[indexPath.row],
              let manageContext = tempToRemove.managedObjectContext else {
            return
        }
        manageContext.delete(tempToRemove)
        do {
            try manageContext.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } catch {
            print("ERROR")
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
