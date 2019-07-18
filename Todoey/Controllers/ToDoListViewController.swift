//
//  ViewController.swift
//  Todoey
//
//  Created by Syeds on 13/07/2019.
//  Copyright © 2019 HMSolutions. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class ToDoListViewController: SwipeTableViewController{
    
    var realm = try! Realm()
    var toDoItems : Results<Item>?
    // to get persistent data storage use userdefaults to add key value pairs
    let defaults = UserDefaults()
    //create a constant i.e data file path which is a path to the new plist file we want to make to hold data
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    @IBOutlet weak var searchBar: UISearchBar!
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
        tableView.separatorStyle = .none
        loadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colourHex = selectedCategory?.color else{fatalError()}
            title = selectedCategory!.name
            navBarColorUpdate(withHexCode: colourHex)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navBarColorUpdate(withHexCode: "1D9BF6")
    }
    
    func navBarColorUpdate(withHexCode colourHexCode : String){
        guard let navbar = navigationController?.navigationBar else{fatalError("Navigation bar does not exist")}
        guard let navbarColor = UIColor(hexString: colourHexCode) else{fatalError()}
        navbar.barTintColor = navbarColor
        navbar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
        searchBar.barTintColor = navbarColor
        navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navbarColor, returnFlat: true)]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            //setting the cell's text
            cell.textLabel?.text = item.title
            if let colour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)){
                 cell.backgroundColor = colour
                 cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
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
                            newItem.dateCreated = Date()
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
    
    //MARK- Delete method
    
    override func updateModel(at IndexPath: IndexPath) {
        
        if let itemForDeletion = toDoItems?[IndexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print("Error saving data \(error)")
            }
        }
    }


}

//MARK: - Extensions

extension ToDoListViewController : UISearchBarDelegate{
    //function related to what happens when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // querying using realm. results items to be set to previous value but filetered
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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
