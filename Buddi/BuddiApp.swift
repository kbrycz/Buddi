//
//  BuddiApp.swift
//  Buddi
//
//  Created by Karl Brycz on 12/15/23.
//

import SwiftUI

@main
struct BuddiApp: App {
    // Create an instance of HomeViewModel
    var viewModel = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            // Pass this viewModel instance to HomeView
            HomeView(viewModel: viewModel)
        }
    }
}
