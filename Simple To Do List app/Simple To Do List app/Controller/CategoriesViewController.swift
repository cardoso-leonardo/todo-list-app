//
//  ViewController.swift
//  Simple To Do List app
//
//  Created by Leonardo Cardoso on 30/09/22.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoriesViewController: UITableViewController {
    
    var categories: Results<Category>!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        loadCategories()
    }
    
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        
        var genericTextField = UITextField()
        
        let alert = UIAlertController(title: "Categories", message: "Add new category", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category()
            newCategory.name = genericTextField.text!
            self.saveCategory(newCategory)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { textField in
            textField.placeholder = "Write a new category"
            genericTextField = textField
        }
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
    
    //MARK: Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
        
    }
    
    
    //MARK: Realm functions
    func saveCategory(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadCategories () {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
}

//MARK: SwipeCellDelegate
extension CategoriesViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let category = self.categories?[indexPath.row] {
                
                do {
                    try self.realm.write {
                        self.realm.delete(category)
                    }
                } catch {
                    print("Erro:\(error)")
                }
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-Icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
}

