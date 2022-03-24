//
//  APIManager.swift
//  viitorCloudPracticalTest
//
//  Created by apple on 24/03/22.
//

import UIKit

enum ResultType {
    case success(Any?), failure(Error)
}

class APIManager: NSObject {
    
    static let shared = APIManager()
    
    override init() {
        super.init()
    }
    
    func getEmployeeList(completion: @escaping (ResultType)->Void){
        var request = URLRequest(url: URL(string: AppConstant.baseURL)!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode([EmployeeModel].self, from: data!)
                completion(.success(responseModel))
            } catch {
                print("JSON Serialization error")
                completion(.failure(error))
            }
        }).resume()
    }
}

