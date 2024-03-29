//
//  Order.swift
//  Restaurant
//
//  Created by Duliba Sviatoslav on 31.05.2022.
//

import Foundation
//MARK: - Structure
struct Order: Codable {
    var menuItems: [MenuItem]

    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
