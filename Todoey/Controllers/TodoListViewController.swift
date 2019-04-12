//
//  ViewController.swift
//  Todoey
//
//  Created by Christian Schmutte on 12.04.19.
//  Copyright © 2019 Christian Schmutte. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{

    var itemsArray = [Item]()
    
    // MARK: viewDidLoad()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item(title: "Find Mike")
        itemsArray.append(newItem)
        
        let newItem2 = Item(title: "Buy Eggos")
        itemsArray.append(newItem2)
        
        let newItem3 = Item(title: "Destroy Demorgon")
        itemsArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemsArray = items
        }
        
    }
    
    

    // MARK: Challenge - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let item = itemsArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: Challenge 2 - TableViewDelegateMethod: selected row does something
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
        
            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks button on UIAlert
                
            self.itemsArray.append(Item(title: textField.text!))
            
            self.defaults.set(self.itemsArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create Item"
            textField = alertTextField
            
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

