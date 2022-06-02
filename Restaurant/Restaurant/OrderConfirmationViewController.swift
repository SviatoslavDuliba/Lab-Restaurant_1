//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Duliba Sviatoslav on 02.06.2022.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
//MARK: - Outlet
    @IBOutlet var confirmationLabel: UILabel!
    
    

    @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder,
               minutesToPrepare: minutesToPrepareOrder)
    }
    //MARK: - Properties
    let minutesToPrepare: Int
    var minutesToPrepareOrder = 0
    
        init?(coder: NSCoder, minutesToPrepare: Int) {
            self.minutesToPrepare = minutesToPrepare
            super.init(coder: coder)
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
    }
}
