//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Duliba Sviatoslav on 02.06.2022.
//

import UIKit

class OrderConfirmationViewController: UIViewController {

    @IBOutlet var confirmationLabel: UILabel!
    
    var minutesToPrepareOrder = 0

    @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder,
               minutesToPrepare: minutesToPrepareOrder)
    }
    let minutesToPrepare: Int
    
        init?(coder: NSCoder, minutesToPrepare: Int) {
            self.minutesToPrepare = minutesToPrepare
            super.init(coder: coder)
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
    }
}
