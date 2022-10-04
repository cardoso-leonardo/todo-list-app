//
//  ItemViewController.swift
//  Simple To Do List app
//
//  Created by Leonardo Cardoso on 04/10/22.
//

import UIKit
import CoreData

class ItemViewController: UITableViewController {
    
    var items = [Items]()
    var selectedCategory : Category? {
        didSet {
            fetchContext()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: Table View Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        if item.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
        saveContext()
    }
    
    //MARK: Add New Item
    
    @IBAction func addItemBarButton(_ sender: UIBarButtonItem) {
        
        var genericTextField = UITextField()
        
        let alert = UIAlertController(title: "New item", message: "Add a new item", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newItem = Items(context: self.context)
            if genericTextField.text == "" {
                newItem.name = "New Item"
            }
            newItem.name = genericTextField.text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.items.append(newItem)
            self.saveContext()
        }
        
        alert.addTextField { textField in
            genericTextField = textField
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
        
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
    
    func fetchContext (with request: NSFetchRequest<Items> = Items.fetchRequest()) {
        
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        request.predicate = predicate
        
        do {
            try items = context.fetch(request)
        } catch {
            print("Error saving context \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
}
