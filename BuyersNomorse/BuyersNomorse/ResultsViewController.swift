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
    
    var minPrice: String?
    var maxPrice: String?
    
    let APIEndPoint = ""
    
    var searchedItem: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func minPriceChanged(_ sender: UITextField) {
    }
    @IBAction func maxPriceChanged(_ sender: UITextField) {
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        if let minPriceString = minPriceTextField.text, let maxPriceString = maxPriceTextField.text {
            minPrice = minPriceString
            maxPrice = maxPriceString
            print(minPrice)
            print(maxPrice)
        }
      
 
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //critics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! ResultsTableViewCell
//        let critic = critics[indexPath.row]
//        cell.criticNameLabel.text = critic.name
//        
//        if let existingImage = critic.image {
//            APIRequestManager.manager.getData(endpoint: (existingImage.link)) { (data: Data?) in
//                if  let validData = data,
//                    let validImage = UIImage(data: validData) {
//                    DispatchQueue.main.async {
//                        cell.criticImage.image = validImage
//                        cell.criticImage.isHidden = false
//                        cell.setNeedsLayout()
//                    }
//                }
//            }
//        } else {
//            cell.criticImage.isHidden = true
//        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let criticSelected = critics[indexPath.row].name
//        let name = criticSelected.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//        
//        APIRequestManager.manager.getData(endpoint: Review.endpoint + "&reviewer=\(name)") { (data) in
//            if let validData = data {
//                self.reviews = Review.getDataFromJSON(data: validData)!
//            }
//            DispatchQueue.main.async{
//                self.collectionView?.reloadData()
//            }
//        }
//    }
//    
//    
}
