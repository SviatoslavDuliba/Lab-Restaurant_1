//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Duliba Sviatoslav on 31.05.2022.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }
    var minutesToPrepareOrder = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(tableView!,selector: #selector(UITableView.reloadData),
                                              name: MenuController.orderUpdatedNotification, object: nil)        
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
            content.text = menuItem.name
            content.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
            content.image = UIImage(systemName: "photo.on.rectangle")
            cell.contentConfiguration = content

//        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
//        var content = cell.defaultContentConfiguration()
//        content.text = menuItem.name
//        content.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
//        content.image = UIImage(systemName: "photo.on.rectangle")
//        cell.contentConfiguration = content
    }

    @IBAction func submitTapped(_ sender: Any) {
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) { (result, menuItem) -> Double in
                return result + menuItem.price
    }

        let formattedTotal = orderTotal.formatted(.currency(code: "usd"))
    
        let alertController = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedTotal)",
                                                preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
                self.uploadOrder()
            }))
        
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
            present(alertController, animated: true, completion: nil)
    }

    func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        Task.init {
            do {
                let minutesToPrepare = try await MenuController.shared.submitOrder(forMenuIDs: menuIds)
                minutesToPrepareOrder = minutesToPrepare
                performSegue(withIdentifier: "confirmOrder", sender: nil)
            } catch {
                displayError(error, title: "Order Submission Failed")
            }
        }
    }
    
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "dismissConfirmation" {
                MenuController.shared.order.menuItems.removeAll()
            }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        }
    }
}
