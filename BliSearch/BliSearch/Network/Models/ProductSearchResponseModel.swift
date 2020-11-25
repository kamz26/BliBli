//
//  ProductSearchResponseModel.swift
//  BliSearch
//
//  
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Welcome
struct ProductSearchResponseModel: Codable {
    let code: Int?
    let status: String?
    let data: ProductSearchResponseData?
}

// MARK: - DataClass
struct ProductSearchResponseData: Codable {
    let pageType: [String]?
    let searchTerm: String?
    let  correctedSearchResponses: [String]?
    let ageRestricted: Bool?
    let products: [Product]?
    let sorting: Sorting?
    let filters: [Filter]?
    let quickFilters: [QuickFilter]?
    let paging: Paging?
    let maxOffers, serverCurrentTime: Int?
    let productInfo: [String: ProductInfo]?
    let code: String?
    let selectedCategoryIDS, visibleCategoryIDS, exclusiveCampProducts: [String]?
    let exclusiveCampRow: Int?
    let responseFlags: [String]?
    let showRestrictedMsg: Bool?
    let redirectionURL: String?
    let trackerFields, intentAttributes, personalizedAttributes, nerAttributes: IntentAttributes?
    let intentApplied, nerApplied, showAllCategories: Bool?
    let searchPageURL: String?
    let catIntentFailed: Bool?
    let sellerAdsPosition: [Int]?
    let nearbyLocationFailed: Bool?
    let correctedNearbyLocation: String?
    let interspersedCardFilters: [String]?

    enum CodingKeys: String, CodingKey {
        case pageType, searchTerm,  correctedSearchResponses, ageRestricted, products, sorting, filters, quickFilters, paging, maxOffers, serverCurrentTime, productInfo, code
        case selectedCategoryIDS = "selectedCategoryIds"
        case visibleCategoryIDS = "visibleCategoryIds"
        case exclusiveCampProducts, exclusiveCampRow, responseFlags, showRestrictedMsg
        case redirectionURL = "redirectionUrl"
        case trackerFields, intentAttributes, personalizedAttributes, nerAttributes, intentApplied, nerApplied, showAllCategories
        case searchPageURL = "searchPageUrl"
        case catIntentFailed, sellerAdsPosition, nearbyLocationFailed, correctedNearbyLocation, interspersedCardFilters
    }
}

// MARK: - Filter
struct Filter: Codable {
    let name, type: String?
    let searchable: Bool?
    let parameter, theme: String?
    let data: [FilterDatum]?
    let horizontal: Bool?
    let sublist: [Sublist]?
    let label: String?
    let parentFacets: [String]?
}

// MARK: - FilterDatum
struct FilterDatum: Codable {
    let label, value: String?
    let count: Int?
    let selected: Bool?
    let promoBatchURL: String?
    let id: String?
    let level: Int?
    let subCategory: [String]?
    let subCategorySelected, restrictedCategory: Bool?
    let code, tooltip: String?
    let tooltipURL: String?
    let tooltipText, query: String?

    enum CodingKeys: String, CodingKey {
        case label, value, count, selected
        case promoBatchURL = "promoBatchUrl"
        case id, level, subCategory, subCategorySelected, restrictedCategory, code, tooltip
        case tooltipURL = "tooltipUrl"
        case tooltipText, query
    }
}

// MARK: - Sublist
struct Sublist: Codable {
    let title, parameter: String?
    let data: [SublistDatum]?
}

// MARK: - SublistDatum
struct SublistDatum: Codable {
    let label, value: String?
    let count: Int?
    let selected: Bool?
}

// MARK: - IntentAttributes
struct IntentAttributes: Codable {
}

// MARK: - Paging
struct Paging: Codable {
    let page, totalPage, itemPerPage, totalItem: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case totalPage = "total_page"
        case itemPerPage = "item_per_page"
        case totalItem = "total_item"
    }
}

// MARK: - ProductInfo
struct ProductInfo: Codable {
    let tags: [String]?
}

// MARK: - Product
struct Product: Codable, Equatable {
    let id, sku, merchantCode, status: String?
    let name: String?
    let price: Price?
    let images: [String]?
    let rootCategory: RootCategory?
    let brand: String?
    let review: Review?
    let itemCount: Int?
    let defaultSku, itemSku: String?
    let tags: [String]?
    let formattedID, url: String?
    let attributes: [Attribute]?
    let productFeatures: String?
    let storeClosingInfo: StoreClosingInfo?
    let promoEndTime: Int?
    let debugData: IntentAttributes?
    let allCategories: [String]?
    let merchantVoucherCount: Int?
    let location: String?
    let numLocations: Int?
    let badge: Badge?
    let official: Bool?

    enum CodingKeys: String, CodingKey {
        case id, sku, merchantCode, status, name, price, images, rootCategory, brand, review, itemCount, defaultSku, itemSku, tags
        case formattedID = "formattedId"
        case url, attributes, productFeatures, storeClosingInfo, promoEndTime, debugData, allCategories, merchantVoucherCount,  location, numLocations, badge, official
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    var productImage: UIImage?
    
    
    
    
    
}

// MARK: - Attribute
struct Attribute: Codable {
    let count: Int?
    let optionListingType: String?
    let values: [String]?
}

// MARK: - Badge
struct Badge: Codable {
    let merchantBadge: String?
}

// MARK: - Price
struct Price: Codable {
    let priceDisplay, strikeThroughPriceDisplay: String?
    let discount, minPrice: Int?
    let offerPriceDisplay: String?
}

// MARK: - Review
struct Review: Codable {
    let rating, count: Int?
}

// MARK: - RootCategory
struct RootCategory: Codable {
    let id, name: String?
}

// MARK: - StoreClosingInfo
struct StoreClosingInfo: Codable {
    let storeClosed: Bool?
    let endDate: Int?
    let delayShipping: Bool?
}

// MARK: - QuickFilter
struct QuickFilter: Codable {
    let name, label, type: String?
    let searchable: Bool?
    let parameter, theme: String?
    let data: [QuickFilterDatum]?
    let horizontal: Bool?
}

// MARK: - QuickFilterDatum
struct QuickFilterDatum: Codable {
    let label, value: String?
    let count: Int?
    let selected: Bool?
    let toolTipURL: String?
    let tooltip: String?
    let tooltipURL: String?
    let tooltipText, parameter: String?

    enum CodingKeys: String, CodingKey {
        case label, value, count, selected
        case toolTipURL = "toolTipUrl"
        case tooltip
        case tooltipURL = "tooltipUrl"
        case tooltipText, parameter
    }
}

// MARK: - Sorting
struct Sorting: Codable {
    let parameter: String?
    let options: [Option]?
}

// MARK: - Option
struct Option: Codable {
    let label, name: String?
    let value: Int?
    let selected: Bool?
}
