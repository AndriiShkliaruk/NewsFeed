//
//  FiltersViewModel.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 12.05.2022.
//

import Foundation

struct FiltersViewModel {
    let applyButtonText = "Apply Filters"
    
    let filterModeViewModel: FilterModeViewModel
    let filterModes: [FilterMode]
    var filterNames: [String] {
        filterModes.map { $0.description }
    }

    init() {
        filterModes = FilterMode.allCases
        filterModeViewModel = FilterModeViewModel()
    }
    
    func filterWithMode(at index: Int) -> FilterModeViewModel {
        return filterModeViewModel.withMode(filterModes[index])
    }
}
