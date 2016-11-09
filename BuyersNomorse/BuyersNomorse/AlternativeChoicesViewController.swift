//
//  AlternativeChoicesViewController.swift
//  BuyersNomorse
//
//  Created by Sabrina Ip on 11/8/16.
//  Copyright © 2016 Sabrina, Shashi. All rights reserved.
//

import UIKit

class AlternativeChoicesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var customerSelection: SearchResults!
    var alternativeItems: [SearchResults]?
    var alternativeEndpoint: String {
        
        /*We need to figure out another way to do randomNum - make sure the categoryId's exist*/
        /* Got error message from ebay: Submitted category [960] has expired. Try again with new category [74969] */
        
        /* maybe make enums for these category nums: http://www.isoldwhat.com/getcats/ */
        
        let randomNum = arc4random_uniform(1000)+1
        let randomCategoryNum = String(randomNum)
        let price = self.customerSelection.currentPrice
        return "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=SabrinaI-GroupPro-PRD-dbff3fe44-d9ad0129&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=30&categoryId=\(randomCategoryNum)&itemFilter(0).name=MaxPrice&itemFilter(0).value=\(price)&itemFilter(1).name=MinPrice&itemFilter(1).value=\(price)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dump custoer slecion")
        dump(customerSelection)
        print("custoer slection title is")
        print(customerSelection.title)
        itemNameLabel.text = customerSelection.title

        APIRequestManager.manager.getData(endPoint: alternativeEndpoint) { (data: Data?) in
            if  let validData = data {
                self.alternativeItems = SearchResults.getDataFromJson(data: validData)
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        print("The alternative endpoint is currently \(self.alternativeEndpoint)")
    }
    
    // MARK: - Navigation
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let alternativeItemsExists = alternativeItems else { return 0 }
        return alternativeItemsExists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlternativeChoice", for: indexPath) as! AlternativeChoicesCollectionViewCell
        
        guard let alternativeItemsExists = alternativeItems else { return cell }
        let item = alternativeItemsExists[indexPath.row]
        
        if let image = item.galleryUrl {
            APIRequestManager.manager.getData(endPoint: image) { (data: Data?) in
                if  let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        cell.alternativeItemImageView.image = validImage
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        return cell
    }

}
