//
//  ViewController.swift
//  Todoey
//
//  Created by Christian Schmutte on 12.04.19.
//  Copyright © 2019 Christian Schmutte. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemsArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        loadItems()
        
        
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
        
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        
//        context.delete(itemsArray[indexPath.row])
//        itemsArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
        
            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks button on UIAlert
            
                guard let textFieldText = textField.text else {return}
                
                
                
                let newItem = Item(context: self.context)
                newItem.title = textFieldText
                newItem.done = false

                self.itemsArray.append(newItem)
            

            
                self.saveItems()
                
                self.tableView.reloadData()
        
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create Item"
            textField = alertTextField
            
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
 
    // MARK: Save Data Method
    
    func saveItems() {
        do {
            try context.save()
            
        } catch {
            print("Failed saving: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        // (with request: NSFetchRequest<Item> = Item.fetchRequest()) provides
        // default value so that if no input is given it has a go to value.
        // This makes a uqnique parameter optional
        
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemsArray = try context.fetch(request)
        } catch {
            print("Failed loading data \(error)")
            
        }
        
        tableView.reloadData()
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()

            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

            loadItems(with: request)
        }
    }
    

}
