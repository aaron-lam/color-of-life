//
//  CategoryViewController.swift
//  ColorOfLife
//
//  Created by Aaron Lam on 8/23/18.
//  Copyright © 2018 Aaron Lam Developer. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import Alamofire
import SwiftyJSON

class CategoryViewController: SwipeTableViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    let realm = try! Realm()
    let quoteURL = "http://quotes.rest/qod.json"
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            setTextandColorInCell(with: category, with: cell)
        }
        return cell
    }
    
    func setTextandColorInCell(with category: Category, with cell: UITableViewCell) {
        cell.textLabel?.text = category.name
        guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write { realm.add(category) }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        requestInfo()
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write { realm.delete(categoryForDeletion) }
            } catch {
                print("Error deleting category, \(error)")
            }
            tableView.reloadData()
        }
    }
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a New Life Goal!", message: "", preferredStyle: .alert)
        // add text field in alert
        alert.addTextField { (field) in
            field.placeholder = "Create new goal"
            textField = field
        }
        // put add action in alert
        alert.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            if (!textField.text!.trimmingCharacters(in: .whitespaces).isEmpty) {
                self.addNewCategory(name: textField.text!)
            }
        })
        // put cancel action in alert
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func addNewCategory(name: String) {
        let newCategory = Category()
        newCategory.name = name
        newCategory.color = UIColor.randomFlat.hexValue()
        self.save(category: newCategory)
    }
    
    //MARK: - Request API
    func requestInfo() {
        Alamofire.request(quoteURL).responseJSON { response in
            if response.result.isSuccess {
                let quoteJSON : JSON = JSON(response.result.value!)
                let arr = quoteJSON["contents"]["quotes"].arrayValue
                self.quoteLabel.text = " " + arr[0]["quote"].stringValue
            }
        }
    }
}
