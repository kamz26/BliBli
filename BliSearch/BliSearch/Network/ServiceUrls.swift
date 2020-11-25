//
//  ServiceUrls.swift
//  BliSearch
//
//  
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import Foundation


public enum APIServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}


enum Service{
    //MARK: - Helper Enums
    enum ServiceUrlTypes{
        static let baseUrl                 = "https://www.blibli.com"
    }
    
    enum QueryItemKey: String {
        case searchTerm                     = "searchTerm"
        case start                          = "start"
        case itemPerPage                    = "itemPerPage"
    }
    
    enum ServiceURLPath:String {
        case search                      = "/backend/search/products"
    }
    
    //MARK: - Base API Url
    case baseAPICall(_ builder: URLBuilder)
    
   
    
    var url: String {
        switch self {
        case .baseAPICall(let builder)
            :return ServiceUrlTypes.baseUrl + "\(builder.path.rawValue)" + "\(getQueryParamString(builder))"
        }
    }
    
    func getQueryParamString(_ builder:URLBuilder) -> String{
        guard builder.queries.count > 0 else {return ""}
        
        var queryString = "?"
        for (index,value) in builder.values.enumerated(){
            queryString.append( index == builder.values.count - 1 ? "\(builder.queries[index].rawValue)=\(value)" : "\(builder.queries[index].rawValue)=\(value)&" )
        }
        return queryString
    }
    
}


struct URLBuilder{
    var path:Service.ServiceURLPath
    var queries:[Service.QueryItemKey]
    var values: [String]
    
    init(_ path:Service.ServiceURLPath, queries:[Service.QueryItemKey] = [], values:[String] = []) {
        
        self.path = path
        self.queries = queries
        self.values  = values
    }
    
}
