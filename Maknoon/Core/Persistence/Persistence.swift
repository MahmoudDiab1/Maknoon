import CoreData
import SwiftUI

enum PersistenceError: LocalizedError {
    case loadError(Error)
    case saveError(Error)
    
    var errorDescription: String? {
        switch self {
        case .loadError(let error):
            return "Failed to load data: \(error.localizedDescription)"
        case .saveError(let error):
            return "Failed to save data: \(error.localizedDescription)"
        }
    }
}

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Create sample data
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Maknoon")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func save() throws {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw PersistenceError.saveError(error)
            }
        }
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(block)
    }
} 
