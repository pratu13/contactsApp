//
//  ContactsViewController.swift
//  Phonebook
//
//  Created by pratyush sharma on 23/05/19.
//  Copyright © 2019 pratyush sharma. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UITableViewController,UISearchBarDelegate, UISearchDisplayDelegate {

    //["name" : "Pratyush","Phone":"245336"]
    var contacts: [NSManagedObject] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetch()
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != ""{
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "name contains[c] '\(searchText)' ")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
            let managedObjectContext  = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact" )
            fetchRequest.predicate = predicate
            do {
                contacts = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error)")
            }
        }
        else{
            fetch()
        }
        tableView.reloadData()
        
    }

    // MARK: - Table view data source
    
    func fetch() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedObjectContext  = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact" )
        do {
            contacts = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func save(name: String,number: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedObjectContext  = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedObjectContext) else {return}
        
        let contact = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        contact.setValue(name, forKey: "name")
        contact.setValue(number, forKey: "number")
        
        
        do {
            try managedObjectContext.save()
            self.contacts.append(contact)
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
    }
    
    func update(indexPath:IndexPath, name: String,number: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedObjectContext  = appDelegate.persistentContainer.viewContext
        let contact = contacts[indexPath.row]
        contact.setValue(name, forKey: "name")
        contact.setValue(number, forKey: "number")
        
        do {
            try managedObjectContext.save()
            contacts[indexPath.row] = contact
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        
    }
    
    func deleteC(contact:NSManagedObject, indexPath:IndexPath){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedObjectContext  = appDelegate.persistentContainer.viewContext
        managedObjectContext.delete(contact)
        managedObjectContext.refreshAllObjects()
        self.contacts.remove(at: indexPath.row)
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)

        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text = contact.value(forKey: "name") as? String
        cell.detailTextLabel?.text = contact.value(forKey: "number") as? String
        
        return cell
    }

    @IBAction  func unwindToContacts(segue: UIStoryboardSegue){
        
        if let viewController = segue.source as? AddViewController{
            guard let name:String = viewController.nameTextField.text else {return}
            guard let number:String = viewController.numberTextField.text  else {return}
             if name != "" && number != "" {
                        if let indexPath = viewController.indexPathForContact {
                            update(indexPath: indexPath, name: name, number: number)
                        }
                        else{
                            save(name: name, number: number)
                        }
                    }
            
           
            print(contacts)
            tableView.reloadData()
        }
        else if let viewController = segue.source as? ContactDetailViewController {
            if viewController.isDeleted{
                guard let index:IndexPath = viewController.indexPath else {return}
                let contact = contacts[index.row]
                deleteC(contact: contact, indexPath: index)
                tableView.reloadData()
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactDetailSegue"{
            guard let navViewController = segue.destination as? UINavigationController else {return}
            guard let viewController =  navViewController.topViewController as? ContactDetailViewController else {return}
            guard let index = tableView.indexPathForSelectedRow else {return }
            let c = contacts[index.row]
            viewController.contact = c
            viewController.indexPath = index
            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
