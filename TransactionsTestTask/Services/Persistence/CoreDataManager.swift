//
//  CoreDataManager.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//


import Foundation
import CoreData

protocol PersistanceManager {
    @MainActor func addAndSaveTransaction(_ transaction: Transaction) throws
    @MainActor func fetchTransactions(limit: Int, offset: Int) throws -> [TransactionDetails]
}

final class CoreDataManager {
    
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "Wallet")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent store: \(error)")
            }
        }

        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    @MainActor
    func saveChanges() throws {
        guard mainContext.hasChanges else { return }
        try mainContext.save()
    }
    
    @MainActor
    func fetch<T: NSManagedObject>(limit: Int? = nil,
                                   offset: Int? = nil,
                                   predicate: NSPredicate? = nil,
                                   sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let request = T.fetchRequest()
        let count = try mainContext.count(for: request)
        
        if let limit {
            request.fetchLimit = limit
        }
        if let offset {
            if offset >= count {
                throw FetchError.noMoreItems
            }
            request.fetchOffset = offset
        }
        
        if let predicate {
            request.predicate = predicate
        }
        if let sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        
        return try mainContext.fetch(request) as! [T]
    }
    
    @MainActor
    func delete<T: NSManagedObject>(_ object: T) throws {
        mainContext.delete(object)
        try saveChanges()
    }
}

extension CoreDataManager: PersistanceManager {
    @MainActor
    func addAndSaveTransaction(_ transaction: Transaction) throws {
        let transactionDetails = TransactionDetails(context: mainContext)
        transactionDetails.date = transaction.date
        transactionDetails.amount = transaction.amount
        transactionDetails.isTopUp = transaction.type == .income
        if case let .expense(category) = transaction.type {
            transactionDetails.category = category.rawValue
        }
        try saveChanges()
    }
    
    @MainActor
    func fetchTransactions(limit: Int, offset: Int) throws -> [TransactionDetails] {
        let sortDescriptor = NSSortDescriptor(keyPath: \TransactionDetails.date, ascending: false)
        return try fetch(limit: limit, offset: offset, sortDescriptors: [sortDescriptor])
    }
}

enum FetchError: Error {
    case noMoreItems
}

