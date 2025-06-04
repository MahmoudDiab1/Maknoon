//
//  MaknoonApp.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 31/05/2025.
//

import SwiftUI
import UIKit

/// The main entry point for the Maknoon Quran application
@main
struct MaknoonApp: App {
    // MARK: - App Configuration
    
    /// Initializes the app and sets up any required configurations
    init() {
        // Configure appearance
        configureAppearance()
        
        // Initialize CoreData
        _ = CoreDataManager.shared
    }
    
    /// Configure the global appearance settings for the app
    private func configureAppearance() {
        // Set navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Convert SwiftUI Color to UIColor
        let mushafBackgroundColor = UIColor(
            red: 0.98,
            green: 0.96,
            blue: 0.93,
            alpha: 1.0
        )
        
        appearance.backgroundColor = mushafBackgroundColor
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        // Apply to all navigation bars
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = mushafBackgroundColor
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    // MARK: - Scene Configuration
    
    var body: some Scene {
        WindowGroup {
            PageEntryView()
        }
    }
} 
