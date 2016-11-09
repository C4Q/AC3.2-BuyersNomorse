//
//  AlternativeChoicesViewController.swift
//  BuyersNomorse
//
//  Created by Sabrina Ip on 11/8/16.
//  Copyright © 2016 Sabrina, Shashi. All rights reserved.
//

fileprivate let catagories = [("antiques", "20081"), ("art","550"), ("baby","2984"), ("books","267"), ("businessAndIndustrial","12576"), ("camerasAndPhoto","625"), ("cellphonesAndAccessories","15032"), ("clothingShoesAndAccessories","11450"),("coinsAndPaperMoney","11116"),("collectibles","1"),("computersTabletsAndNetworking","58058"),("consumerElectronics","293"),("crafts","14339"),("dollsAndBears","237"),("moviesAndDVDs","11232"),("entertainmentMemorabilia","45100"),("everythingElse","99"),("giftCardsAndCoupons","172008"),("healthAndBeauty","26395"), ("homeAndGarden","11700"),("jewelryAndWatches","281"), ("music","11233"),("musicalInstrumentsAndGear","619"),("petSupplies","1281"), (")potteryAndGlass","870"),("realEstate","10542"),("specialtyServices","316"),("sportingGoods","888"),("sportsMemCardsAndFanShop","64482"), ("stamps","260"),("ticketsAndExperiences","1305"),("toysAndHobbies","220"),("travel","3252"),("videoGamesAndConsoles","1249")]


fileprivate func randomCatogoryGenerator() -> String {
    let rand = Int(arc4random_uniform(34))
    return catagories[rand].1
}


import UIKit

class AlternativeChoicesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var alternativeItemsHeader: UILabel!
    
    
    
    
    //var alternativeItemSelected: SearchResults?
    var alternativeItemHeaderText = ""
    var customerSelection: SearchResults!
    var alternativeItems: [SearchResults]?
    var alternativeEndpoint: String {

        let randomCategory = randomCatogoryGenerator()
        let price = self.customerSelection.currentPrice
        return "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=SabrinaI-GroupPro-PRD-dbff3fe44-d9ad0129&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=30&categoryId=\(randomCategory)&itemFilter(0).name=MaxPrice&itemFilter(0).value=\(price)&itemFilter(1).name=MinPrice&itemFilter(1).value=\(price)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameLabel.text = customerSelection.title
        alternativeItemsHeader.text = alternativeItemHeaderText
        
        
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
    
    //Trying to add popover segue
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "ShowAlternativeDetails" {
//            var vc = segue.destination as! PopoverViewController
//            
//            var controller = vc.popoverPresentationController
//            
//            if controller != nil {
//                controller?.delegate = self
//            }
////            if let cell = sender as? AlternativeChoicesCollectionViewCell {
////                if let destinationVC = segue.destination as? PopoverViewController {
////                    
////                    var controller = destinationVC.popoverPresentationController
////                    
////                    if controller != nil {
////                        controller?.delegate = self
////                        if let indexPath = self.collectionView.indexPath(for: cell) {
////                            alternativeItemSelected = self.alternativeItems?[indexPath.row]
////                            //destinationVC.customerSelection = itemSelected
////                            print("*************************")
////                            print(alternativeItemSelected)
////                            print("*************************")
////                        }
////                    }
////                }
////            }
//        }
//    }
//    
//    @IBAction func popover(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "ShowAlternativeDetails", sender: self)
//    }
//    
//
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }
//    
}
