//
//  ContactDetailProvider.swift
//  MyContactApp
//
//  Created by SourabhMehta on 22/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import Foundation


/*### ContactDetailProvider
 
 Provides methods for fetching the contact detail from the server
 */
public struct ContactDetailProvider {
    
    /**
     Get contact Details
     
     - parameter detailsURL: URL to get the detail of the contact 
     - parameter completion:         Completion closure expression
     */
     @discardableResult static   func contactsDetails(withContactString detailsURL : String,withCompletion completion: @escaping (Response<Contact>) -> Void) -> URLSessionDataTask? {
        
        return APIClient.request(from: detailsURL, with: [:], methodType: get, withCompletion: { (result: Response<Data>) in
            switch result {
            case .success(let data):
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let list = try? decoder.decode(Contact.self, from: data)
                
                if let detail = list {
                    completion(.success(detail))
                }
            case .failure(_):
                completion(.failure(ContactError.noContactRetrieved))
            }
        })
    }
    
    /**
     Put Favorite status of the contact
     - parameter id:           id of the contact 
     - parameter messageBody: detail of the contact in key value pair
     - parameter completion:         Completion closure expression
     */
    @discardableResult static   func setFavoriteStatus(withContactId id : Int,with messageBody : NSDictionary,withCompletion completion: @escaping (Response<Data>) -> Void) -> URLSessionDataTask? {
        let url = Constants.Config.baseURL +  "/" +  String(id) + Constants.Config.requestURL
        return APIClient.request(from: url, with: messageBody, methodType: put,withCompletion: { (result: Response<Data>) in
            switch result {
            case .success(let data):
                    completion(.success(data))
            case .failure(_):
                completion(.failure(ContactError.noContactRetrieved))
            }
        })
    }
    
}
