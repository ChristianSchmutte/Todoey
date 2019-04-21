//
//  ViewController.swift
//  Todoey
//
//  Created by Christian Schmutte on 12.04.19.
//  Copyright © 2019 Christian Schmutte. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var todoItems: Results<Item>?
    var cgColorPercentage: CGFloat = 80
    var colorFromCategory: UIColor = .blue
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var addButtonOutlet: UIBarButtonItem!
    
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        print(cgColorPercentage)
        print("times 0.8 \(cgColorPercentage * 0.8)")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let setColorHex = selectedCategory?.colorHex else {fatalError("No selected category color hex")}
        setNavBar(withHexCode: setColorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        setNavBar(withHexCode: "1D9BF6")
        
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
    }
    
    // MARK: - Nav Bar Setup
    func setNavBar(withHexCode colorHexCode: String ) {
        
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        guard let navBarColor =  UIColor(hexString: colorHexCode) else {fatalError("Navbar color is nil")}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        
        searchBarOutlet.barTintColor = UIColor(hexString: colorHexCode)
    }
    
    // MARK: Challenge - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done  ? .checkmark : .none
            
            if let color = UIColor(hexString: item.itemColorHex)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // MARK: Challenge 2 - TableViewDelegateMethod: selected row does something
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }

        }
        
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: nil, preferredStyle: .alert)
        
            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
                guard let textFieldText = textField.text else {return}
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textFieldText
                            newItem.dateCreated = Date()
                            newItem.itemColorHex = self.selectedCategory!.colorHex
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving items, \(error)")
                    }
                }

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
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    // MARK: - Delete Method
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("error deleting todo item, \(error)")
            }
            
        }
        
    }

    
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {



    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        } else {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
            
            tableView.reloadData()
            
        }
    }


}
