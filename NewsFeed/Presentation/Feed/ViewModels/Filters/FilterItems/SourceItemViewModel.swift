//
//  SourceItemViewModel.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 13.05.2022.
//

import Foundation

class SourceItemViewModel: FilterItemViewModel {
    let id: String
    
    init(id: String, name: String) {
        self.id = id
        super.init(name: name)
    }
}
