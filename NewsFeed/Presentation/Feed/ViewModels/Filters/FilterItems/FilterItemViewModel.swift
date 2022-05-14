//
//  FilterItemViewModel.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 13.05.2022.
//

import Foundation

class FilterItemViewModel {
    let name: String
    var isSelected = false
    
    init(name: String) {
        self.name = name
    }
}
