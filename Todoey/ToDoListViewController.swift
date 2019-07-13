//
//  ViewController.swift
//  Todoey
//
//  Created by Syeds on 13/07/2019.
//  Copyright © 2019 HMSolutions. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController{
    
    let itemArray = ["Buy eggs","Get an iPad","Comnplete course"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    //MARK - TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        
        return cell
        
    }
    
    //MARK - Table view Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // adding accessorlitem such as a check mark the cell
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //to remove the persistent colour change for selection add the following call
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

