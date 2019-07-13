//
//  ViewController.swift
//  Todoey
//
//  Created by Syeds on 13/07/2019.
//  Copyright © 2019 HMSolutions. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    // to get persistent data storage use userdefaults to add key value pairs
    let defaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // how to acces the stored data
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = items
        }
        let newItem = Item()
        newItem.title = "Buy Groceries"
        itemArray.append(newItem)
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    //MARK - TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        //setting the cell's text
        cell.textLabel?.text = item.title
        //setting the checkmark on or off based on internal boolean
        // use ternary operator to reduce code
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
        
    }
    
    //MARK - Table view Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
        //to remove the persistent colour change for selection add the following call
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        // create an alert controller
        let alert = UIAlertController(title: "Add Item", message: "Add a new Item", preferredStyle: .alert)
        // create alert action i.e. what is to be done
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if (textField.text != ""){
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)// change the data input to item from string
                //add data to the userdefaults
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                // really important! have to reload the view to have datasource re-rendered
                self.tableView.reloadData()
            }
        }
        // add textfield to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        
        // add action as alert's action
        alert.addAction(action)
        // choose how to present the whole thing
        present(alert,animated: true, completion: nil)
        
    }
    
    
    
}
