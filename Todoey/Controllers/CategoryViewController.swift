//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Syeds on 14/07/2019.
//  Copyright © 2019 HMSolutions. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
    
    
    let realm = try! Realm()
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray?[indexPath.row]
        
        //setting the cell's text
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        //setting the checkmark on or off based on internal boolean
        
        return cell
        
    }

    //MARK: - Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToDoItems", sender: self)
       // save()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // create a variable that taps into the segue destination that is casted as ToDoListViewController
        let destinationVC = segue.destination as! ToDoListViewController
        //to get the row selected, assign the tableView indexpathof selected row to indexpath variable
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        //category array is asked to look into realm and all objects belonging to it  and look for all Category objects
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new category"
        }
        
        present(alert, animated: true, completion: nil)
    }


}
