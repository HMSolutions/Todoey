//
//  ViewController.swift
//  Todoey
//
//  Created by Syeds on 13/07/2019.
//  Copyright © 2019 HMSolutions. All rights reserved.
//

import UIKit
import RealmSwift


class ToDoListViewController: UITableViewController{
    
    var realm = try! Realm()
    var toDoItems : Results<Item>?
    // to get persistent data storage use userdefaults to add key value pairs
    let defaults = UserDefaults()
    //create a constant i.e data file path which is a path to the new plist file we want to make to hold data
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    /*************************************************************************************/
    
    //creating selectedCategory variable to identify which category has been selected
    var selectedCategory : Category?{
        didSet{
//            loadData()
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
        return toDoItems?.count ?? 1
    }

    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            //setting the cell's text
            cell.textLabel?.text = item.title
            //setting the checkmark on or off based on internal boolean
            // use ternary operator to reduce code
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added yet"
        }

        return cell
        
    }
    
    //MARK: - Table view Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    // to delete
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        
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
                if let currentCategory = self.selectedCategory{
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            currentCategory.item.append(newItem)
                        }
                    }catch{
                        print("Error saving data \(error)")
                    }
                   
                    self.tableView.reloadData()
                }
                

            }
        }

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

    func loadData(){
        
        toDoItems = selectedCategory?.item.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }


}

//MARK: - Extensions

//extension ToDoListViewController : UISearchBarDelegate{
//    //function related to what happens when search button is clicked
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // create a request of type NSfetch request type containing an array of Item objects
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        //create a predicate which queries the database
//        //format is like columns to be searched and any patterns
//        // argument is what is in the search bar
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        //add the query to the request
//        request.predicate = predicate
//        // if you want to sort the search results
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        //add sortdescriptor to the request which accepts an array
//        request.sortDescriptors = [sortDescriptor]
//
//        loadData(with: request, predicate: predicate)
//    }
//
//    // to restore the list before search
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if (searchBar.text?.count == 0){
//            loadData()
//            //for changing user interface behaviors always use queue manager and its main thread and then async
//            DispatchQueue.main.async {
//                //dismiss selection/focus from search bar i.e. stop being first responder
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//}
