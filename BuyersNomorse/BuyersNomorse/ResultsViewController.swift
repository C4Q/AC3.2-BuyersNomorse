//
//  ResultsViewController.swift
//  BuyersNomorse
//
//  Created by Sabrina Ip on 11/8/16.
//  Copyright © 2016 Sabrina, Shashi. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var minPriceTextField: UITextField!
    @IBOutlet weak var maxPriceTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var errorLabel: UILabel!
    var minPrice: String?
    var maxPrice: String?
    var searchedItem = ""
    
    var endpoint: String {
        var filterCount = 0
        let keywordInput = self.searchedItem.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var webAddress = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=SabrinaI-GroupPro-PRD-dbff3fe44-d9ad0129&RESPONSE-DATA-FORMAT=JSON&paginationInput.entriesPerPage=25&keywords=\(keywordInput)"
        if let maxPriceEntered = self.maxPrice {
            webAddress += "&itemFilter(\(filterCount)).name=MaxPrice&itemFilter(\(filterCount)).value=\(maxPriceEntered)"
            filterCount += 1
        }
        if let minPriceEntered = self.minPrice {
            webAddress += "&itemFilter(\(filterCount)).name=MinPrice&itemFilter(\(filterCount)).value=\(minPriceEntered)"
        }
        return webAddress
    }
    
    var itemSelected: SearchResults?
    var items: [SearchResults]?
    // var sortedItems: [SearchResults]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    

    
//    func sortSmallestToLargest {
//        let unsortedItems = SearchResults.getDataFromJson(data: validData)
//        self.items = unsortedItems?.sorted { (a, b) -> Bool in
//            
//            var isSmaller = false
//            let aPrice: Double? = Double(a.currentPrice)
//            let bPrice: Double? = Double(b.currentPrice)
//            
//            if let aP = aPrice, let bP = bPrice {
//                isSmaller = aP < bP
//            }
//            return isSmaller
//        }
//
//    }
    
    func loadData() {
        APIRequestManager.manager.getData(endPoint: self.endpoint) { (data: Data?) in
            if  let validData = data {
                self.items = SearchResults.getDataFromJson(data: validData)
            }
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    @IBAction func minPriceChanged(_ sender: UITextField) {
    }
    @IBAction func maxPriceChanged(_ sender: UITextField) {
    }
    //    func sortItems(arrItems: [SearchResults]) -> [SearchResults] {
    //
    ////        for i in 0..<arrItems.count {
    ////            if arrItems[i]
    ////        }t
    //        var newArray = arrItems.sorted { (a, b) -> Bool in
    //            Int(a.currentPrice)! < Int(b.currentPrice)!
    //        }
    //
    //        return newArray
    //    }
    
    func sortSmallestToLargest() {
        self.items = items?.sorted(by: { (a, b) -> Bool in
            guard let aPrice = Double(a.currentPrice),
                let bPrice = Double(b.currentPrice) else { return true }
            return aPrice < bPrice
        })
    }
    

    func minMaxAreAcceptableAnswers() -> Bool {
        var minPDouble: Double?
        var maxPDouble: Double?
        
        minPrice = nil
        maxPrice = nil
        
        if minPriceTextField.text! != "" {
            guard let minNum = Double(minPriceTextField.text!) else {
                errorLabel.text = "The minimum price is not a valid answer"
                return false
            }
            minPDouble = minNum
            minPrice = String(minNum)
        }
        
        if maxPriceTextField.text! != "" {
            guard let maxNum = Double(maxPriceTextField.text!) else {
                errorLabel.text = "The maximum price is not a valid answer"
                return false
            }
            maxPDouble = maxNum
            maxPrice = String(maxNum)
        }
        
        if let minExists = minPDouble, let maxExists = maxPDouble {
            guard minExists < maxExists else {
                errorLabel.text = "Minimum should be less than Maximum"
                return false
            }
        }
        
        print("min price is \(minPrice)")
        print("MAX price is \(maxPrice)")
        return true
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        print("min price textfield is showing \(minPriceTextField.text)")
        print("MAX price textfield is showing \(maxPriceTextField.text)")
        
        guard minMaxAreAcceptableAnswers() else {
            errorLabel.isHidden = false
            return
        }
        errorLabel.isHidden = true
        print("The endpoint is currently \(self.endpoint)")
        loadData()

    }
    
/* Need to connect this button to storyboard
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        sortSmallestToLargest()
        loadData()
    }
*/
    
    // MARK: - TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemsExists = items else { return 0 }
        return itemsExists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! ResultsTableViewCell
        guard let itemsExists = items else { return cell }
        let item = itemsExists[indexPath.row]
        
        cell.itemTitleLabel.text = item.title
        var currentPrice = item.currentPrice
        currentPrice.insert("$", at: currentPrice.startIndex)
        cell.itemPriceLabel.text = currentPrice
        
        //Loads Image Async
        if let image = item.galleryUrl {
            APIRequestManager.manager.getData(endPoint: image) { (data: Data?) in
                if  let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        cell.itemImageView.image = validImage
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToAlternativeViewController" {
            if let cell = sender as? ResultsTableViewCell {
                if let destinationVC = segue.destination as? AlternativeChoicesViewController {
                    if let indexPath = self.tableView.indexPath(for: cell) {
                        if let itemSelected = self.items?[indexPath.row] {
                            destinationVC.customerSelection = itemSelected
                            //Trying to format the price into US Currency format
                            var currentPrice = NSDecimalNumber(string: itemSelected.currentPrice)
                            //Source (Lines 207-211): http://stackoverflow.com/questions/39458003/swift-3-and-numberformatter-currency-
                            let numberFormatter = NumberFormatter()
                            numberFormatter.numberStyle = .currency
                            numberFormatter.locale = Locale(identifier: "en_us")
                            if let result = numberFormatter.string(from: currentPrice) {
                            destinationVC.alternativeItemHeaderText = "Other Items That Cost \(result)"
                            }
                            destinationVC.alternativeItemImageURLString = itemSelected.viewItemUrl
                            if let image = itemSelected.galleryUrl {
                                APIRequestManager.manager.getData(endPoint: image) { (data: Data?) in
                                    if  let validData = data,
                                        let validImage = UIImage(data: validData) {
                                        DispatchQueue.main.async {
                                            
                                            destinationVC.itemImageButton.setBackgroundImage(validImage, for: UIControlState.normal)
//
                                            cell.setNeedsLayout()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}
