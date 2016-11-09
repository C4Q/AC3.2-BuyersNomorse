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
        return constructAlternativeEndpoint()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameLabel.text = customerSelection.title

        APIRequestManager.manager.getData(endPoint: alternativeEndpoint) { (data: Data?) in
            if  let validData = data {
                self.alternativeItems = SearchResults.getDataFromJson(data: validData)
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }

    func constructAlternativeEndpoint() -> String {
        let randomNum = arc4random_uniform(1000)+1
        let randomCategoryNum = String(randomNum)
        let price = self.customerSelection.currentPrice
        return "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=SabrinaI-GroupPro-PRD-dbff3fe44-d9ad0129&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=25&categoryId=\(randomCategoryNum)&itemFilter(0).name=MaxPrice&itemFilter(0).value=\(price)&itemFilter(1).name=MinPrice&itemFilter(1).value=\(price)"
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
        
        APIRequestManager.manager.getData(endPoint: item.galleryUrl) { (data: Data?) in
            if  let validData = data,
                let validImage = UIImage(data: validData) {
                DispatchQueue.main.async {
                    cell.alternativeItemImageView.image = validImage
                    cell.setNeedsLayout()
                }
            }
        }
        
        return cell
    }
    

}
