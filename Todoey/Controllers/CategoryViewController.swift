//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Syeds on 14/07/2019.
//  Copyright © 2019 HMSolutions. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        //remove separators between cells
        tableView.separatorStyle = .none
    }


    
    
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
         let category = categoryArray?[indexPath.row]
        
            cell.textLabel?.text = category!.name ?? "No categories added yet"
        
        if let cellColor = UIColor(hexString: category!.color){
            cell.backgroundColor = cellColor
            cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
        }
            //cell.backgroundColor = UIColor.randomFlat
            //cell.backgroundColor = GradientColor(UIGradientStyle, frame:CGRect, colors:[FlatRed()])
        
        
            return cell
    
        //setting the cell's text
       
        //setting the checkmark on or off based on internal boolean
        
        
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
    
    //MARK- Delete method
    
    override func updateModel(at IndexPath: IndexPath) {
        
        if let categoryForDeletion = categoryArray?[IndexPath.row]{
        do{
            try self.realm.write {
                self.realm.delete(categoryForDeletion)
            }
        }catch{
            print("Error saving data \(error)")
        }
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
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
