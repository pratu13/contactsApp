//
//  ContactDetailViewController.swift
//  Phonebook
//
//  Created by pratyush sharma on 24/05/19.
//  Copyright © 2019 pratyush sharma. All rights reserved.
//

import UIKit
import  CoreData

class ContactDetailViewController: UIViewController {

    var contact: NSManagedObject? = nil
    var isDeleted: Bool = false
    var indexPath : IndexPath? = nil
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = contact?.value(forKey: "name") as? String
        number.text = contact?.value(forKey: "number") as? String
        // Do any additional setup after loading the view.
    }
  
    
    @IBAction func delCon(_ sender: Any) {
        isDeleted = true
        performSegue(withIdentifier: "unwindToContact", sender: self)
    }
    
    @IBAction func done(_ sender: Any) {
        
        performSegue(withIdentifier : "unwindToContact", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            guard let viewController = segue.destination as? AddViewController else {return}
            viewController.titleText = "Edit Contact"
            viewController.contact = contact
            viewController.indexPathForContact = self.indexPath!
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
