//
//  AppDelegate.swift
//  viitorCloudPracticalTest
//
//  Created by apple on 24/03/22.
//

import UIKit
import IQKeyboardManagerSwift
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "db")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        setApplicationRoot()
        return true
    }
}

extension AppDelegate{
    
    //MARK: - Set Application Root View
    private func setApplicationRoot(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let movieListVC = LoginViewController()
        let rootNavigationController = UINavigationController(rootViewController: movieListVC)
        self.window?.rootViewController = rootNavigationController
        self.window?.makeKeyAndVisible()
    }
}

extension AppDelegate{

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
