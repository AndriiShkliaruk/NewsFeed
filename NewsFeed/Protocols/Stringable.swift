//
//  Stringable.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 10.05.2022.
//

import Foundation

protocol Stringable { }

extension Stringable where Self: RawRepresentable, RawValue == String {
    var string: String {
        rawValue
    }
}
