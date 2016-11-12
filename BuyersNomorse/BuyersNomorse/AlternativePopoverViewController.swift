//
//  AlternativePopoverViewController.swift
//  BuyersNomorse
//
//  Created by Madushani Lekam Wasam Liyanage on 11/10/16.
//  Copyright © 2016 Sabrina, Shashi, Erica. All rights reserved.
//

import UIKit

class AlternativePopoverViewController: UIViewController, UIPopoverControllerDelegate {
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var alternativeItemNameLabel: UILabel!
    @IBOutlet weak var alternativeItemPriceLabel: UILabel!
    
    var itemImage: String?
    
    
    var alternativeItem: SearchResults?
    
    @IBAction func alternativeItemImageButtonTapped(_ sender: UIButton) {
        if let alternativeItemURL = URL(string: (alternativeItem?.viewItemUrl)!) {
            UIApplication.shared.open(alternativeItemURL)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        alternativeItemNameLabel.text = alternativeItem?.title
        
        if let itemPrice = alternativeItem?.currentPrice {
            //Returns properly formatted currency
            let currentPrice = NSDecimalNumber(string: itemPrice)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = Locale(identifier: "en_us")
            if let result = numberFormatter.string(from: currentPrice) {
                alternativeItemPriceLabel.text = result
            }
        }
        
        guard let alternativeItemsExists = alternativeItem else { return }
        
        if let plusImage = alternativeItemsExists.galleryPlusPictureUrl {
            itemImage = plusImage
            
        }
        else if let smallImage = alternativeItem?.galleryUrl {
            itemImage = smallImage
        }
        
        if let image = itemImage {
            APIRequestManager.manager.getData(endPoint: image) { (data: Data?) in
                if  let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        self.imageButton.setBackgroundImage(validImage, for: UIControlState.normal)
                    }
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func prepareForReuse() {
        self.imageButton.imageView?.image = nil
    }
    
    
}
