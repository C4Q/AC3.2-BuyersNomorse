//
//  SearchResult.swift
//  BuyersNomorse
//
//  Created by Sabrina Ip on 11/8/16.
//  Copyright © 2016 Sabrina, Shashi. All rights reserved.
//

import Foundation

// http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=SabrinaI-GroupPro-PRD-dbff3fe44-d9ad0129&itemFilter(0).name=MaxPrice&itemFilter(0).value=7.50&itemFilter(1).name=MinPrice&itemFilter(1).value=7.50&paginationInput.entriesPerPage=10&categoryId=1281&keywords=cheap&RESPONSE-DATA-FORMAT=JSON

enum searchResultParseError: Error {
    case jsonSerialization
    case name
}

class SearchResult {
    let title: String
    let galleryUrl: String
    let viewItemUrl: String
    let currentPrice: String
    let categoryId: String
    let categoryName: String
    
    init(title: String, galleryUrl: String, viewItemUrl: String, currentPrice: String, categoryId: String, categoryName: String) {
        self.title = title
        self.galleryUrl = galleryUrl
        self.viewItemUrl = viewItemUrl
        self.currentPrice = currentPrice
        self.categoryId = categoryId
        self.categoryName = categoryName
    }
    
    static func getDataFromJson(data: Data) -> [SearchResult]? {
        var searchResults = [SearchResult]()
        
        //        do {
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        guard let response = jsonData as? [String: Any],
            let findItemsAdvancedResponse = response["findItemsAdvancedResponse"] as? [[String: Any]],
            let theResults = findItemsAdvancedResponse[0]["searchResult"] as? [[String:Any]],
            let item = theResults[0]["item"] as? [[String: Any]]
            else {
                return nil
        }
        
        for itemObject in item {
            guard let titleArr = itemObject["title"] as? [String],
                let title = titleArr[0] as? String,
                let primaryCategory = itemObject["primaryCategory"] as? [[String: Any]],
                let categoryIdArr = primaryCategory[0]["categoryId"] as? [String],
                let categoryId = categoryIdArr[0] as? String,
                let categoryNameArr = primaryCategory[0]["categoryName"] as? [String],
                let categoryName = categoryNameArr[0] as? String
                
                else {
                    return nil
            }
        }
        
        //
        //            for criticObject in results {
        //                guard let criticName = criticObject["display_name"] as? String else {
        //                    throw CriticModelParseError.name
        //                }
        //
        //                var bio: String? = nil
        //
        //                if let biograpgy = criticObject["bio"] as? String {
        //                    bio = biograpgy
        //                }
        //
        //                var image: Image? = nil
        //
        //                if let multimedia = criticObject["multimedia"] as? [String: AnyObject],
        //                    let resource = multimedia["resource"] as? [String: AnyObject] {
        //                    image = Image(from: resource)
        //                }
        //
        //                let c = Critic(name: criticName,
        //                               image: image,
        //                               bio: bio)
        //                critics.append(c)
        //            }
        //
        //        } catch CriticModelParseError.jsonSerialization {
        //            print("jsonSerialization error")
        //        } catch CriticModelParseError.name {
        //            print("name error")
        //        } catch {
        //            print(error)
        //        }
        
        return searchResults
    }
    
}
