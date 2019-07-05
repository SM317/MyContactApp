//
//  EditContactProvider.swift
//  MyContactApp
//
//  Created by SourabhMehta on 23/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import Foundation


/*### EditContactProvider
 
 Provides methods for updating the contact detail to the server
 */
public struct EditContactProvider {
    
    /**
     updation of the contact
     - parameter id:           id of the contact
     - parameter messageBody:  detail of the contact in key value pair
     - parameter completion:   Completion closure expression
     */
    @discardableResult static   func updateContact(withContactId id : Int,with messageBody : NSDictionary,withCompletion completion: @escaping (Response<Data>) -> Void) -> URLSessionDataTask? {
        let url = Constants.Config.baseURL +  "/" +  String(id) + Constants.Config.requestURL
        return APIClient.request(from: url, with: messageBody, methodType: put, withCompletion: { (result: Response<Data>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                completion(.failure(ContactError.noContactRetrieved))
            }
        })
    }
    
    /**
     creation  of the new contact
     - parameter id:           id of the contact
     - parameter messageBody:  detail of the contact in key value pair
     - parameter completion:   Completion closure expression
     */
    @discardableResult static   func createContact(withContactId id : Int,with messageBody : NSDictionary,withCompletion completion: @escaping (Response<Data>) -> Void) -> URLSessionDataTask? {
        let url = Constants.Config.baseURL + "/"
        return APIClient.request(from: url, with: messageBody, methodType: post, withCompletion: { (result: Response<Data>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                completion(.failure(ContactError.noContactRetrieved))
            }
        })
    }
    
}
