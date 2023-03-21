//
//  CategoryViewController.swift
//  Todoey
//
//  Created by M. Ahmad Ali on 18/03/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
     
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 70.0
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added yet"  
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        //        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let category = categoryArray?[indexPath.row]
            destinationVC.selectedCategory = category
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func saveCategory(category: Object ) {
        do {
            try realm.write  {
                realm.add(category)
            }
        } catch {
            print("Error Savig Context: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error Deleting Category: \(error.localizedDescription)")
                }
            }
        }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if textField.text?.count != 0 {
                let newCategory = Category()
                newCategory.name = textField.text!
                
                self.saveCategory(category: newCategory)
                
            } else {
                let alert = UIAlertController(title: "Enter a category name", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}

//MARK: - UISearchBarDelegate

extension CategoryViewController: UISearchBarDelegate {
    
    //MARK: - SearchBarMethods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        categoryArray = categoryArray?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    //    if no  input passed in searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
