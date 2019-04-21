//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Christian Schmutte on 14.04.19.
//  Copyright © 2019 Christian Schmutte. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadCategories()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories, \(error)")
        }
        
        
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            super.updateModel(at: indexPath)
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion.items)
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting catgegory, \(error)")
            }
            
        }
    }
    
    // MARK: - CHALLENGE: Store random colors
    
    /*
     Chameleon framework can put out and take in hex values.
     The task is to give the categories a color string property
     which will be generated randomly while creating the object.
     Therefore:
     1. Go through documentation how to GENERATE hex string
     2. Go through documentation how to IMPLEMENT hex string to get same color
     3. Edit data model to have property of hex color string
     4. edit cellForRowAt so that cell background gets categories color
     5. BONUS: use catorgories color to use it for todos to have a fade
        of the same color of the categorie.
     
     
     */

    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        
        if let loadedCategory = categories?[indexPath.row] {
            cell.textLabel?.text = loadedCategory.name
            guard let bgColor = UIColor(hexString: loadedCategory.colorHex) else {fatalError("Could not create color from hex string")}
            cell.backgroundColor = bgColor
            cell.textLabel?.textColor = ContrastColorOf(bgColor, returnFlat: true)
            
        }
        
        return cell
    }
    
    // MARK: - TODO: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    // MARK: -  Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            
            guard let textFieldText = textField.text else {return}
            
            let newCategory = Category()
            newCategory.name = textFieldText
            newCategory.colorHex = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

// MARK: - Swipe Cell Delegate Methods
