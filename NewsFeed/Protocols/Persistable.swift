//
//  Persistable.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 14.05.2022.
//

import Foundation
import RealmSwift

public protocol Persistable {
    associatedtype ManagedObject: Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
