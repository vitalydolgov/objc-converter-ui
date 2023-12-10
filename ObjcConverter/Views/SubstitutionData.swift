//
//  SubstitutionData.swift
//  ObjC Converter
//
//  Created by Vitaly Dolgov on 12/10/23.
//

import CoreData

protocol SubstitutionDataPr {
    var substitutions: [Substitution] { get }
    subscript(substitutionID: ObjectIdentifier) -> Substitution { get set }
    func addNew()
    func remove(with: Set<ObjectIdentifier>)
    func reload()
}

class SubstitutionData: ObservableObject, SubstitutionDataPr {
    var managedContext: NSManagedObjectContext
    @Published var substitutions = [Substitution]()
    
    subscript(substitutionID: ObjectIdentifier) -> Substitution {
        get {
            guard let substitution = substitutions.first(where: { $0.id == substitutionID }) else {
                return Substitution()
            }
            return substitution
        }
        set(newValue) {
            guard let index = substitutions.firstIndex(where: { $0.id == newValue.id }) else {
                return
            }
            substitutions[index] = newValue
            try? managedContext.save()
        }
    }
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
        self.substitutions = fetch()
    }
    
    func addNew() {
        let substitution = Substitution(context: managedContext)
        substitution.regex = "/regex/replac/"
        try? managedContext.save()
        reload()
    }
    
    func remove(with ids: Set<ObjectIdentifier>) {
        let filtered = ids.compactMap { id in substitutions.first(where: { $0.id == id }) }
        for substitution in filtered {
            managedContext.delete(substitution)
        }
        let _ = try? managedContext.save()
        reload()
    }
    
    func reload() {
        substitutions = fetch()
    }
    
    private func fetch() -> [Substitution] {
        let request = NSFetchRequest<Substitution>(entityName: "Substitution")
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        guard let records = try? managedContext.fetch(request) else {
            return []
        }
        return records
    }
}
