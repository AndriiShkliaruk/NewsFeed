//
//  FilterModeViewModel.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 13.05.2022.
//

import Foundation

enum FilterMode: String, CaseIterable {
    case category
    case country
    case sources
    
    var description: String {
        rawValue.capitalized
    }
}

class FilterModeViewModel {
    let apiManager = NewsAPIManager()
    var mode: FilterMode?
    var delegate: FetchCompletionDelegate?
    
    private let categories: [FilterItemViewModel]
    private let countries: [FilterItemViewModel]
    private var sources: [SourceItemViewModel]?
    
    var selectedCountry: String? {
        countries.first(where: { $0.isSelected })?.name.lowercased()
    }
    
    var selectedCategory: String? {
        categories.first(where: { $0.isSelected })?.name.lowercased()
    }
    
    var selectedSourcesIDs: String? {
        guard let sources = sources else { return nil }
        return sources.filter { $0.isSelected }.map { $0.id }.joined(separator: ",")
    }
    
    var filterItems: [FilterItemViewModel] {
        switch mode {
        case .category:
            return categories
        case .country:
            return countries
        case .sources:
            return sources ?? []
        case .none:
            return []
        }
    }
    
    init() {
        categories = Category.allCases.map { FilterItemViewModel(name: $0.string.capitalized) }
        countries = Country.allCases.map { FilterItemViewModel(name: $0.string.uppercased()) }
    }
    
    func selectDefaultCountry(_ country: Country) {
        countries.first(where: { $0.name == country.string.uppercased() })?.isSelected = true
    }
    
    func withMode(_ mode: FilterMode) -> Self {
        self.mode = mode
        return self
    }
    
    func fetchSources() {
        apiManager.fetchSources(country: selectedCountry, category: selectedCategory) { [unowned self] fetchedSources in
            let newSourcesViewModels: [SourceItemViewModel] = fetchedSources.compactMap { source in
                guard let id = source.id else { return nil }
                return SourceItemViewModel(id: id, name: source.name)
            }
            
            updateSources(newSourcesViewModels)
            DispatchQueue.main.async {
                self.delegate?.onFetchCompleted()
            }
        }
    }
    
    func selectFilterItem(at index: Int) {
        switch mode {
        case .category:
            categories[index].isSelected.toggle()
        case .country:
            countries[index].isSelected.toggle()
            deselectAllItems(in: countries.filter { $0.name != countries[index].name })
        case .sources:
            sources?[index].isSelected.toggle()
        case .none:
            break
        }
    }
    
    private func deselectAllItems(in items: [FilterItemViewModel]) {
        items.forEach { $0.isSelected = false }
    }
    
    private func updateSources(_ newSources: [SourceItemViewModel]) {
        if let sources = sources {
            for newSource in newSources {
                if sources.contains(where: { $0.id == newSource.id && $0.isSelected }) {
                    newSource.isSelected = true
                }
            }
        }
        self.sources = newSources
    }
}
