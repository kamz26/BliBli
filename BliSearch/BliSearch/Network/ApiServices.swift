//
//  ApiServices.swift
//  BliSearch
//
//  
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import Foundation

final class ApiServices{
    
   public static let shared = ApiServices()
    
   private init(){}

    
    func getProductSearchList<T:Codable>(query:String,currentPage:Int,_ objectType: T.Type, completion: @escaping (Result<T, APIServiceError>) -> Void){
       
        let urlBuilder = URLBuilder(.search, queries: [.searchTerm,.start,.itemPerPage], values: [query,currentPage.description,"10"])
        
        let url = Service.baseAPICall(urlBuilder).url
        
        commonAPICall(url: url, T.self, completion: completion)
    }
    
}


extension ApiServices{
    
    fileprivate var urlSession: URLSession {
        return URLSession.shared
    }
    
    fileprivate var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }
    
    
    func commonAPICall<T:Codable>(url: String, params: [String:Any]? = nil,_ objectType: T.Type, completion: @escaping  (Result<T, APIServiceError>) -> Void){
        
        guard let url = URL(string: url) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let task = urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    Log.printLog(error)
                    completion(.failure(.decodeError))
                }
            case .failure( _):
                completion(.failure(.apiError))
            }
        }
        task.resume()
    }
}




class Log: NSObject {
    class func printLog(_ items: Any...) {
        print(items)
    }
}
