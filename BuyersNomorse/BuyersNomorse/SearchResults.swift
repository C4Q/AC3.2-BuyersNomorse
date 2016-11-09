//
//  SearchResult.swift
//  BuyersNomorse
//
//  Created by Sabrina Ip on 11/8/16.
//  Copyright © 2016 Sabrina, Shashi. All rights reserved.
//

import Foundation

enum searchResultParseError: Error {
    case jsonSerialization
    case getResults
}

class SearchResults {
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
    
    static func getDataFromJson(data: Data) -> [SearchResults]? {
        var searchResults = [SearchResults]()
        
        do {
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let response = jsonData as? [String: Any],
                let findItemsAdvancedResponse = response["findItemsAdvancedResponse"] as? [[String: Any]],
                let theResults = findItemsAdvancedResponse[0]["searchResult"] as? [[String:Any]],
                let item = theResults[0]["item"] as? [[String: Any]]
                else { throw searchResultParseError.jsonSerialization }
            
            for itemObject in item {
                guard let titleArr = itemObject["title"] as? [Any],
                    let title = titleArr[0] as? String,
                    
                    let primaryCategory = itemObject["primaryCategory"] as? [[String: Any]],
                    let categoryIdArr = primaryCategory[0]["categoryId"] as? [Any],
                    let categoryId = categoryIdArr[0] as? String,
                    
                    let categoryNameArr = primaryCategory[0]["categoryName"] as? [Any],
                    let categoryName = categoryNameArr[0] as? String,
                    
                    let galleryUrlArr = itemObject["galleryURL"] as? [Any],
                    let galleryUrl = galleryUrlArr[0] as? String,
                    
                    let viewItemURLArr = itemObject["viewItemURL"] as? [Any],
                    let viewItemUrl = viewItemURLArr[0] as? String,
                    
                    let sellingStatus = itemObject["sellingStatus"] as? [[String:Any]],
                    let convertedPrice = sellingStatus[0]["convertedCurrentPrice"] as? [[String:String]],
                    let currentPrice = convertedPrice[0]["__value__"]
                    else { throw searchResultParseError.getResults }
                
                let sr = SearchResults(title: title, galleryUrl: galleryUrl, viewItemUrl: viewItemUrl, currentPrice: currentPrice, categoryId: categoryId, categoryName: categoryName)
                searchResults.append(sr)
            }
        } catch searchResultParseError.jsonSerialization {
            print("jsonSerialization error")
        }catch searchResultParseError.getResults {
            print("get results parsing error")
        }catch {
            print(error)
        }
        
        return searchResults
    }
}
