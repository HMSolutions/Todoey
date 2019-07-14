//
//  ViewController.swift
//  Todoey
//
//  Created by Syeds on 13/07/2019.
//  Copyright © 2019 HMSolutions. All rights reserved.
//

import UIKit
import CoreData


class ToDoListViewController: UITableViewController{
    
    
    //use an encoder to encode data to CoreData by getting the superclass object and casting
    //it explicitly to Appdelegate and accessing its properties and methods
    // aim is to get the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    // to get persistent data storage use userdefaults to add key value pairs
    let defaults = UserDefaults()
    //create a constant i.e data file path which is a path to the new plist file we want to make to hold data
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    /*************************************************************************************/
    
    //creating selectedCategory variable to identify which category has been selected
    var selectedCategory : Category?{
        didSet{
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // how to acces the stored data
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
//            itemArray = items
//        }

        loadData()

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    //MARK: - TableView Datasource methods
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
    
    //MARK: - Table view Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // to delete upon clicking use the following lines commented out
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        saveItems()
        
        //switching boolean value
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        //to remove the persistent colour change for selection add the following call
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        // create an alert controller
        let alert = UIAlertController(title: "Add Item", message: "Add a new Item", preferredStyle: .alert)
        // create alert action i.e. what is to be done
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if (textField.text != ""){
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)// change the data input to item from string
                //add data to the userdefaults
//                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                self.saveItems()
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
    
    
    //MARK: - Model Manipulation Methods
    //Refactoring to create a method for encoding and saving data
    func saveItems (){

        do{
            try context.save()
        }catch{
            print("Error saving context! \(error)")
        }
        
        // really important! have to reload the view to have datasource re-rendered
       tableView.reloadData()
    }
    
    //decoding data from custom plist file to use in the app
    func loadData(with request:NSFetchRequest<Item>  = Item.fetchRequest(), predicate : NSPredicate? = nil){
        //have to explicity mention data type
        //it is same data taype as returned by context.fetch(request) below
        //create a predicate so that result is filtered by parent category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //compound predicate
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
           itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
    

}

//MARK: - Extensions

extension ToDoListViewController : UISearchBarDelegate{
    //function related to what happens when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // create a request of type NSfetch request type containing an array of Item objects
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //create a predicate which queries the database
        //format is like columns to be searched and any patterns
        // argument is what is in the search bar
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //add the query to the request
        request.predicate = predicate
        // if you want to sort the search results
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        //add sortdescriptor to the request which accepts an array
        request.sortDescriptors = [sortDescriptor]
        
        loadData(with: request, predicate: predicate)
    }
    
    // to restore the list before search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0){
            loadData()
            //for changing user interface behaviors always use queue manager and its main thread and then async
            DispatchQueue.main.async {
                //dismiss selection/focus from search bar i.e. stop being first responder
                searchBar.resignFirstResponder()
            }
           
        }
    }
}
