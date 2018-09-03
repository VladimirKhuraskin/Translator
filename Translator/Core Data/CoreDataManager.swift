//
//  CoreDataManager.swift
//  Translator
//
//  Created by Vladimir Khuraskin on 03.09.2018.
//  Copyright © 2018 Vladimir Khuraskin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Translator")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(sourceLang: String, targetLang: String, originalText: String, translationText: String) {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "History", in: managedContext)
        guard let historyObject = NSManagedObject(entity: entity!, insertInto: managedContext) as? History else { return }
        historyObject.setValue(sourceLang, forKeyPath: "sourceLang")
        historyObject.setValue(targetLang, forKeyPath: "targetLang")
        historyObject.setValue(originalText, forKeyPath: "originalText")
        historyObject.setValue(translationText, forKeyPath: "translationText")
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(fromHistory historyElement: History) {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        managedContext.delete(historyElement)
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchHistory() -> [History]? {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        do {
            let history = try managedContext.fetch(fetchRequest)
            return history
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private init() {}
    
}
