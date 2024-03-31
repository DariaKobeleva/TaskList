//
//  StorageManager.swift
//  TaskList
//
//  Created by Дарья Кобелева on 30.03.2024.
//

import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    //Точка входа в базу данных
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //MARK: - Methods CRUD
    func fetchData() -> [ToDoTask] {
        let fetchRequest = ToDoTask.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return[]
        }
    }
    
    func create(_ taskName: String) {
        let task = ToDoTask(context: persistentContainer.viewContext)
        task.title = taskName
        
        saveContext()
    }
    
    func update(_ task: ToDoTask, withNewTitle newTitle: String) {
        task.title = newTitle
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func delete(_ task: ToDoTask) {
        persistentContainer.viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    //Момент сохранения в базу данных
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    private init() {}
}

