import CoreData
import os.log

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.maknoon",
        category: "CoreData"
    )
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "QuranCache")
        container.loadPersistentStores { [weak self] description, error in
            if let error = error {
                self?.logger.error("Failed to load Core Data stack: \(error.localizedDescription)")
                fatalError("Failed to load Core Data stack: \(error)")
            }
            self?.logger.info("Successfully loaded Core Data stack")
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                logger.info("Successfully saved Core Data context")
            } catch {
                logger.error("Failed to save Core Data context: \(error.localizedDescription)")
            }
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { [weak self] context in
            block(context)
            if context.hasChanges {
                do {
                    try context.save()
                    self?.logger.info("Successfully saved background context")
                } catch {
                    self?.logger.error("Failed to save background context: \(error.localizedDescription)")
                }
            }
        }
    }
} 