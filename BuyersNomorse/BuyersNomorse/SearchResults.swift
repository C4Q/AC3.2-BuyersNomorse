//
//  SearchResult.swift
//  BuyersNomorse
//
//  Created by Sabrina Ip on 11/8/16.
//  Copyright © 2016 Sabrina, Shashi, Erica. All rights reserved.
//

import Foundation

internal enum jsonSerialization: Error {
    case response(jsonData: Any)
    case findItemsAdvancedResponse(response: [String: AnyObject])
    case theResults(findItemsAdvancedResponse: [[String : AnyObject]])
    case item(theResults: [[String : AnyObject]])
}

internal enum searchResultParseError: Error {
    case titleArr(itemObject: Dictionary<String, AnyObject>)
    case title(titleArr: [AnyObject])
    case primaryCategory(itemObject: Dictionary<String, AnyObject>)
    case categoryIdArr(primaryCategory: [[String : AnyObject]])
    case categoryId(categoryIdArr: [AnyObject])
    case categoryNameArr(primaryCategory: [[String : AnyObject]])
    case categoryName(categoryNameArr: [AnyObject])
    case viewItemURLArr(itemObject: Dictionary<String, AnyObject>)
    case viewItemUrl(viewItemURLArr: [AnyObject])
    case sellingStatus(itemObject: Dictionary<String, AnyObject>)
    case convertedPrice(sellingStatus: [[String : AnyObject]])
    case currentPrice(convertedPrice: [[String : String]])
}

//"galleryPlusPictureURL": [
//"http://galleryplus.ebayimg.com/ws/web/182190036074_1_3_1_00000003.jpg"
//]

class SearchResults {
    let title: String
    let galleryUrl: String?
    let viewItemUrl: String
    let currentPrice: String
    let categoryId: String
    let categoryName: String
    let galleryPlusPictureUrl: String?
    
    init(title: String, galleryUrl: String?, viewItemUrl: String, currentPrice: String, categoryId: String, categoryName: String, galleryPlusPictureUrl: String?) {
        self.title = title
        self.galleryUrl = galleryUrl
        self.viewItemUrl = viewItemUrl
        self.currentPrice = currentPrice
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.galleryPlusPictureUrl = galleryPlusPictureUrl
    }
    
    static func getDataFromJson(data: Data) -> [SearchResults]? {
        var searchResults = [SearchResults]()
        
        do {
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response = jsonData as? [String: AnyObject] else {
                throw jsonSerialization.response(jsonData: jsonData as Any)
            }
            guard let findItemsAdvancedResponse = response["findItemsAdvancedResponse"] as? [[String: AnyObject]] else {
                throw jsonSerialization.findItemsAdvancedResponse(response: response)
            }
            guard let theResults = findItemsAdvancedResponse[0]["searchResult"] as? [[String:AnyObject]] else {
                throw jsonSerialization.theResults(findItemsAdvancedResponse: findItemsAdvancedResponse)
            }
            
            guard let item = theResults[0]["item"] as? [[String: AnyObject]] else {
                throw jsonSerialization.item(theResults: theResults)
            }
            
            for itemObject in item {
                guard let titleArr = itemObject["title"] as? [AnyObject] else {
                    throw searchResultParseError.titleArr(itemObject: itemObject)
                }
                guard let title = titleArr[0] as? String else {
                    throw searchResultParseError.title(titleArr: titleArr)
                }
                
                guard let primaryCategory = itemObject["primaryCategory"] as? [[String: AnyObject]] else {
                    throw searchResultParseError.primaryCategory(itemObject: itemObject)
                }
                guard let categoryIdArr = primaryCategory[0]["categoryId"] as? [AnyObject] else {
                    throw searchResultParseError.categoryIdArr(primaryCategory: primaryCategory)
                }
                guard let categoryId = categoryIdArr[0] as? String else {
                    throw searchResultParseError.categoryId(categoryIdArr: categoryIdArr)
                }
                    
                guard let categoryNameArr = primaryCategory[0]["categoryName"] as? [AnyObject] else {
                    throw searchResultParseError.categoryNameArr(primaryCategory: primaryCategory)
                }
                guard let categoryName = categoryNameArr[0] as? String else {
                    throw searchResultParseError.categoryName(categoryNameArr: categoryNameArr)
                }
                    

                    
                guard let viewItemURLArr = itemObject["viewItemURL"] as? [AnyObject] else {
                    throw searchResultParseError.viewItemURLArr(itemObject: itemObject)
                }
                guard let viewItemUrl = viewItemURLArr[0] as? String else {
                    throw searchResultParseError.viewItemUrl(viewItemURLArr: viewItemURLArr)
                }
                    
                guard let sellingStatus = itemObject["sellingStatus"] as? [[String:AnyObject]] else {
                    throw searchResultParseError.sellingStatus(itemObject: itemObject)
                }
                guard let convertedPrice = sellingStatus[0]["convertedCurrentPrice"] as? [[String:String]] else {
                    throw searchResultParseError.convertedPrice(sellingStatus: sellingStatus)
                }
                guard let currentPrice = convertedPrice[0]["__value__"] else {
                    throw searchResultParseError.currentPrice(convertedPrice: convertedPrice)
                }
                
                var galleryUrl: String?
                var galleryPlusPictureUrl: String?
                
                if let galleryUrlArr = itemObject["galleryURL"] as? [AnyObject] {
                    galleryUrl = galleryUrlArr[0] as? String
                }
                if let galleryPlusPictureUrlArr = itemObject["galleryPlusPictureURL"] as? [AnyObject] {
                    galleryPlusPictureUrl = galleryPlusPictureUrlArr[0] as? String
                }
                
                let sr = SearchResults(title: title, galleryUrl: galleryUrl, viewItemUrl: viewItemUrl, currentPrice: currentPrice, categoryId: categoryId, categoryName: categoryName, galleryPlusPictureUrl: galleryPlusPictureUrl)
                searchResults.append(sr)
            }
        } catch let jsonSerialization.response(jsonData: jsonData) {
            print("PARSE ERROR: \(jsonData)")
        } catch let jsonSerialization.findItemsAdvancedResponse(response: response) {
            print("PARSE ERROR: \(response)")
        } catch let jsonSerialization.theResults(findItemsAdvancedResponse: findItemsAdvancedResponse) {
            print("PARSE ERROR: \(findItemsAdvancedResponse)")
        } catch let jsonSerialization.item(theResults: theResults) {
            print("PARSE ERROR: \(theResults)")
        } catch let searchResultParseError.titleArr(itemObject: itemObject) {
            print("PARSE ERROR: \(itemObject)")
        } catch let searchResultParseError.title(titleArr: titleArr) {
            print("PARSE ERROR: \(titleArr)")
        } catch let searchResultParseError.primaryCategory(itemObject: itemObject) {
            print("PARSE ERROR: \(itemObject)")
        } catch let searchResultParseError.categoryIdArr(primaryCategory: primaryCategory) {
            print("PARSE ERROR: \(primaryCategory)")
        } catch let searchResultParseError.categoryId(categoryIdArr: categoryIdArr) {
            print("PARSE ERROR: \(categoryIdArr)")
        } catch let searchResultParseError.categoryNameArr(primaryCategory: primaryCategory) {
            print("PARSE ERROR: \(primaryCategory)")
        } catch let searchResultParseError.categoryName(categoryNameArr: categoryNameArr) {
            print("PARSE ERROR: \(categoryNameArr)")
        } catch let searchResultParseError.viewItemURLArr(itemObject: itemObject) {
            print("PARSE ERROR: \(itemObject)")
        } catch let searchResultParseError.viewItemUrl(viewItemURLArr: viewItemURLArr) {
            print("PARSE ERROR: \(viewItemURLArr)")
        } catch let searchResultParseError.sellingStatus(itemObject: itemObject) {
            print("PARSE ERROR: \(itemObject)")
        } catch let searchResultParseError.convertedPrice(sellingStatus: sellingStatus) {
            print("PARSE ERROR: \(sellingStatus)")
        } catch let searchResultParseError.currentPrice(convertedPrice: convertedPrice) {
            print("PARSE ERROR: \(convertedPrice)")
        } catch {
            print(error)
        }
        
        return searchResults
    }
}
