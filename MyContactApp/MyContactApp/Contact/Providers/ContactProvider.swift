//
//  ContactProviders.swift
//  MyContactApp
//
//  Created by SourabhMehta on 21/06/19.
//  Copyright © 2019 Sourabh. All rights reserved.
//

import Foundation
import UIKit


/*### ContactProvider

Provides methods for fetching the contact list from the server
*/
public struct ContactProvider {
    
    /**
     Get all contacts
     - parameter completion:         Completion closure expression
     */
        @discardableResult static  func contacts(withCompletion completion: @escaping (Response<[Contact]>) -> Void) -> URLSessionDataTask? {
        
        let url = Constants.Config.baseURL + Constants.Config.requestURL
            return APIClient.request(from: url, with: [:], methodType: get, withCompletion: { (result: Response<Data>) in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let list = try? decoder.decode([Contact].self, from: data)
                
                if let contactList = list, contactList.count > 0 {
                      completion(.success(contactList))
                }
            case .failure(_):
                completion(.failure(ContactError.noContactRetrieved))
            }
        })
    }
    
    /**
     Get all contacts with index titles
     - parameter contacts:         Array of all the contacts get from above method
     */
    static func getAllContactsWithIndex(contacts : [Contact]) -> [ContactListSection]
    {
        let sortedContacts = contacts.sorted(by: { $0.fullName < $1.fullName })
        let sectionTitles = UILocalizedIndexedCollation.current().sectionTitles
        var calicutaingSections: [ContactListSection] = []
        for title in sectionTitles {
            let contacts = sortedContacts.filter({ $0.fullName.capitalized.hasPrefix(title)})
            let section = ContactListSection.init(sectionTitle: title, contacts: contacts)
            calicutaingSections.append(section)
        }
        return calicutaingSections
    }

}
