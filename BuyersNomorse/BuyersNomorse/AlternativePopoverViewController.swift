//
//  AlternativePopoverViewController.swift
//  BuyersNomorse
//
//  Created by Madushani Lekam Wasam Liyanage on 11/10/16.
//  Copyright © 2016 Sabrina, Shashi, Erica. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit

class AlternativePopoverViewController: UIViewController, UIPopoverControllerDelegate {
    
    @IBOutlet weak var alternativeImageButton: UIButton!
    
    @IBOutlet weak var alternativeItemNameLabel: UILabel!
    @IBOutlet weak var alternativeItemPriceLabel: UILabel!
    
    @IBOutlet weak var alternativeCategoryLabel: UILabel!
    var itemImage: String?
    
    
    var alternativeItem: SearchResults?
  
    
    @IBAction func alternativeImageButtonTapped(_ sender: UIButton) {
        if let alternativeItemURL = URL(string: (alternativeItem?.viewItemUrl)!) {
            UIApplication.shared.open(alternativeItemURL)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        alternativeItemNameLabel.text = alternativeItem?.title
        alternativeCategoryLabel.text = "Category: \((alternativeItem?.categoryName)!)"
        
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
                        self.alternativeImageButton.setBackgroundImage(validImage, for: UIControlState.normal)
                    }
                }
                
            }
        }
        
        
        //http://studyswift.blogspot.com/2016/01/facebook-sdk-and-swift-post-message-and.html
        //Creates share button
        
        let urlImage = NSURL(string: (self.alternativeItem?.galleryUrl)!)
        
        let content = FBSDKShareLinkContent()
        content.contentTitle = alternativeItem?.title
        content.imageURL = urlImage as URL!
        
        let shareButton = FBSDKShareButton()
        shareButton.center = CGPoint(x: view.center.x, y: view.center.y+35)
        shareButton.shareContent = content
        view.addSubview(shareButton)
    }
    
    
//    let topEdgeConstraint = NSLayoutConstraint(item: button,
//                                               attribute: .Top,
//                                               relatedBy: .Equal,
//                                               toItem: upperView,
//                                               attribute: attribute,
//                                               multiplier: 1.0,
//                                               constant: 15.0)

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func prepareForReuse() {
        //self.imageButton.imageView?.image = nil
    }
    
    
}
