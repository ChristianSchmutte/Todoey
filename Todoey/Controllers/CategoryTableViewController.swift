//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Christian Schmutte on 14.04.19.
//  Copyright © 2019 Christian Schmutte. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Catagory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()

    }
    
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving categories, \(error)")
        }
        
        
    }
    
    func loadCategories(with request: NSFetchRequest<Catagory> = Catagory.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories, \(error)")
        }
        
        tableView.reloadData()
        
    }


    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "goToItems")
        cell.textLabel?.text = categories[indexPath.row].name
        
        
        return cell
    }
    
    // MARK: - TODO: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
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
            
            let newCategory = Catagory(context: self.context)
            newCategory.name = textFieldText
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
