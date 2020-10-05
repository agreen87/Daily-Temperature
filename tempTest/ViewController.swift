//
//  ViewController.swift
//  tempTest
//
//  Created by Amanda Green on 8/17/20.
//  Copyright © 2020 Amanda Green. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    var students: [Child] = []
    var selectedName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }
        let  managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        
        do {
            students = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("ERROR")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell")
        let student = students[indexPath.row]
        cell?.textLabel?.text = student.name
        cell?.detailTextLabel?.text = student.classroom
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? TemperatureViewController,
              let selectedRow = self.tableView.indexPathForSelectedRow?.row
        else {
            return
        }
        destination.students = students[selectedRow]
        destination.myStudent = selectedName
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete")
        {(action, view, completionHandler) in
            
            self.deleteStudent(at: indexPath)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            
            let studentToEdit = self.students[indexPath.row]
            
            let alert = UIAlertController(title: "Edit Person", message: "Edit name and/or class:", preferredStyle: .alert)
            alert.addTextField()
            
            alert.addTextField()
            
            let textField = alert.textFields![0]
            textField.text = studentToEdit.name
            textField.autocapitalizationType = .words
            
            let textFieldTwo = alert.textFields![1]
            textFieldTwo.text = studentToEdit.classroom
            textField.autocapitalizationType = .words
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
                
                let textField = alert.textFields![0]
                let textFieldTwo = alert.textFields![1]
                
                studentToEdit.name = textField.text
                studentToEdit.classroom = textFieldTwo.text
                
                do {
                    try self.context.save()
                    tableView.reloadData()
                } catch {
                    print("ERROR")
                }
            }
            alert.addAction(cancelButton)
            alert.addAction(saveButton)
            self.present(alert, animated: true, completion: nil)
        }
        return UISwipeActionsConfiguration(actions: [action, edit])
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add a Student", message: "Enter a student's name and class.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Student Name"
            textField.autocapitalizationType = .words
        })
        alert.addTextField (configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Student Class"
            textField.autocapitalizationType = .words
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        let submitButton = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            let textField = alert.textFields![0]
            let textFieldTwo = alert.textFields![1]
            
            if (textField.text!.isEmpty || textFieldTwo.text!.isEmpty) {
                self.showAlert()
            } else {
                let newStudent = Child(name: textField.text!, classroom: textFieldTwo.text!)
                
                do {
                    try newStudent?.managedObjectContext?.save()
                    
                } catch {
                    print("Could not save!")
                    
                }
                self.fetchStudents()
            }
        }
        
        alert.addAction(cancelButton)
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchStudents() {
        
        do {
            self.students = try context.fetch(Child.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("ERROR")
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Required", message: "Enter a name and class to add a student.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteStudent(at indexPath: IndexPath) {
        
        let studentToRemove = self.students[indexPath.row]
        
        guard let managedContext = studentToRemove.managedObjectContext else {
            return
        }
        
        managedContext.delete(studentToRemove)
        
        do {
            try managedContext.save()
            students.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("ERROR")
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

