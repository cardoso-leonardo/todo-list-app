//
//  ViewController.swift
//  Simple To Do List app
//
//  Created by Leonardo Cardoso on 30/09/22.
//

import UIKit
import CoreData

class CategoriesViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContext()
    }
    
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        
        var genericTextField = UITextField()
        
        let alert = UIAlertController(title: "Categories", message: "Add new category", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category(context: self.context)
            newCategory.name = genericTextField.text
            self.categories.append(newCategory)
            self.saveContext()
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
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
       
    }
    
    
    //MARK: Context functions
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func fetchContext () {
        do {
            try categories = context.fetch(Category.fetchRequest())
        } catch {
            print("Error saving context \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
}

