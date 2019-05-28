//
//  AddViewController.swift
//  Phonebook
//
//  Created by pratyush sharma on 23/05/19.
//  Copyright © 2019 pratyush sharma. All rights reserved.
//

import UIKit
import CoreData
class AddViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    var titleText = "Add Contact"
    var contact: NSManagedObject? = nil
    var contact1: [NSManagedObject] = []
    var contact2: [NSManagedObject] = []
    
    var indexPathForContact: IndexPath? = nil

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var numberTextField: UITextField!
    
    
    @IBAction func addContact(_ sender: Any) {
        
        
        let number = numberTextField.text
        let name = nameTextField.text
        let isThere:Bool = search(name: name!, number: number!)
        if !isThere {
            if number!.starts(with: "(+91)") {
                if number?.count == 15 {
                     performSegue(withIdentifier: "unwindToContactList", sender: self)
                }else{
                    displayAlert(userMessage: "Number Length must be max 10 digits")
                }
            }else{
                displayAlert(userMessage: "Number should start with +91")
            }
        }else{
                displayAlert(userMessage: "Name and Number already exists in database")
            }
        }
    func search(name: String,number:String) -> Bool {
        
        var predicate: NSPredicate = NSPredicate()
        var predicate1: NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "name contains[c] '\(name)' ")
        predicate1 = NSPredicate(format: "name contains[c] '\(number)' ")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext  = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact" )
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact" )
        fetchRequest.predicate = predicate
        fetchRequest1.predicate = predicate1
        
        do{
            contact1 = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            let db = contact1.map { $0.value(forKey: "name") as! String }
            contact2 = try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            let db1 = contact1.map { $0.value(forKey: "number") as! String }
        
            if  db.first ==  name && db1.first == number {
                return true
            }
            else{
                return false
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return true
        
    }
    
    func displayAlert(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction: UIAlertAction!
        okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        nameTextField.text = nil
        numberTextField.text = nil
        performSegue(withIdentifier: "unwindToContactList", sender: self)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        if let contact = self.contact{
            nameTextField.text = contact.value(forKey: "name") as? String
            numberTextField.text = contact.value(forKey: "number") as? String
        }

        // Do any additional setup after loading the view.
    }
    
    
    
    


}
