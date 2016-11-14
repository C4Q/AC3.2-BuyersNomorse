# Project: Buyers Nomorse

A shopping app called “!impulse” that gives you alternative buying choices for the price of the item you have searched for.

## Erica

### Facebook Integration

Goal: Allow users to sign-in and share interesting findings with friends.

#### Part 1: Configuring the Facebook SDK for iOS 

* SDK == Software Developer Kit
* A set of frameworks that allow us to _“easily”_ integrate our apps with Facebook
  * "A framework is a hierarchial directory that encapsulates shared resources in a single package" (Source: [More on Frameworks](https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WhatAreFrameworks.html))
  * Examples of Shared Resources: shared library, nib files, image files, localized strings, header files, and reference documentation 
* [Link to Getting Started with the Facebook SDK for iOS](https://developers.facebook.com/docs/ios/getting-started/) -> Let's go through the basic setup process together!

**_Where Things Got Real_**

Step 5: Connecting App Delegate to FBSDKApplication Delegate Object via AppDelegate.m:

* Programming in Swift -> AppDelegate.swift (We have no AppDelegate.m)
* Why?: “The simple answer is that AppDelegate.swift is just a translation from AppDelegate.h and AppDelegate.m, as Swift does not require separate headers & implementations” (Source: [StackOverflow](http://stackoverflow.com/questions/30388064/how-does-appdelegate-swift-replace-appdelegate-h-and-appdelegate-m-in-xcode-6-3))
* **_Workaround:_ Create a Swift Bridging Header File & add it to Target’s Build Settings**
  * A Swift bridging header allows you to communicate with Obj-C classes from Swift classes. Needed if your (Swift) program utilizes Obj-C
  * [Quick & Dirty Resource For How to Create a Bridging Header File](http://www.learnswiftonline.com/getting-started/adding-swift-bridging-header/)
  * Once this step is complete, you will be able to access all of the APIs in the Facebook SDK in our comfy Swift language/file system
  * This is the source code we used in our `Bridging-Header.h` file:

```
#ifndef Bridging_Header_h
#define Bridgin_Header_h

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Bolts/Bolts.h>

#endif /* Bridging_Header_h */
```
  * Now, we can update `AppDelegate.swift`:

> Side Note: _After_ I already completed most of the processes described above, I found out that there is a [Facebook SDK for Swift](https://developers.facebook.com/docs/swift) that would have probably been so much easier to work with, but I was pretty much done at that point. At least I now have some experience bridging Objective-C and Swift! :)


Step 1: Import Kits
```swift
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
```

Step 2: Update the Following Methods
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    return true

}

func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(app, open: url as URL!, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
}

func applicationDidBecomeActive(_ application: UIApplication) {
    FBSDKAppEvents.activateApp()
}
```

  * At this point, the SDK is installed and configured. The easiest way to test this is by using the App Event, **Log App Activations**. We have already done this in the AppDelegate.swift file by calling the activateApp() method on the FBSDKAppEvents class. To check:
    * Compile & Run App
    * Go to the [Analytics for Apps Dashboard](https://www.facebook.com/analytics/373837896292654/) & select your app
    * From the menu on the left, select Activity -> Events


#### Part 2: Implementing Capabilites and/or Other App Events

**_Example 1: Login with Facebook_**

In the view controller that you wish to display the login button, simply add the following inside of `viewDidLoad()`. (Don't forget to import `FBSDKLoginKit!`):
```swift
import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
```
[Source](http://studyswift.blogspot.com/2016/01/facebook-sdk-and-swift-create-facebook.html)

Yay! At this point, you should be able to log in to Facebook from your app. However, I noticed that the prompt on the login did not change after my credentials were authenticated. I was logged in, but the button still said, "Log in with Facebook". To fix this, implement the following delegate methods & set your button delegate:

```swift
class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        //...        
        loginButton.delegate = self
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Successfully logged in with facebook...")
    }
}
```
[Source](https://videos.letsbuildthatapp.com/playlist/Firebase-Social-Login/video/Facebook-Authentication-and-Cocoapods)

Your login in button should now prompt you to Log Out once are successfully authenticated. 

**_Example 2: Add Sharing Capabilites_**

In the view controller you wish to add the Facebook Share Button to, add the following to the viewDidLoad() method and import the Kits below: 

```swift
import UIKit
import FBSDKLoginKit
import FBSDKShareKit

class ViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlImage = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/0/0e/THSR_700T_Modern_High_Speed_Train.jpg")

        let imageView = UIImageView(frame: CGRectMake(0, 0, 200, 200))
        imageView.center = CGPoint(x: view.center.x, y: 200)
        imageView.image = UIImage(data: NSData(contentsOfURL: urlImage!)!)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        view.addSubview(imageView)

        let content = FBSDKShareLinkContent()
        content.contentTitle = "Taiwan High Speed Rail. Posted with my iOS App."
        content.imageURL = urlImage

        let shareButton = FBSDKShareButton()
        shareButton.center = CGPoint(x: view.center.x, y: 500)
        shareButton.shareContent = content
        view.addSubview(shareButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
```
[Source](http://studyswift.blogspot.com/2016/01/facebook-sdk-and-swift-post-message-and.html)

**_Example 3: Add Like Button_**

Instead of using a tutorial, let's do this one straight from [Facebook's Developer Site](https://developers.facebook.com/docs/sharing/ios/like-button)

We're going to need this nifty [Objective-C -> Swift Converter](https://objectivec2swift.com/#/home/main)

#### Other Resources
* [Quickstart Link for Facebook SDK Integration] (https://developers.facebook.com/quickstarts/?platform=ios)
* [More Info on Facebook Analytics](https://developers.facebook.com/docs/analytics)

## Sabrina

### Going through eBay's API

1. Register for an eBay developer account here: http://developer.ebay.com/join
2. You will need a production key, which can be requested here: http://developer.ebay.com/my/keys. Save the App ID (Client ID) to be used for later.
3. Now, find the API you would like to work with. This page categorizes API by types:  https://go.developer.ebay.com/api-documentation.
4. For this project, we chose an API that can search through eBay’s inventory. Thus, find the heading that says “Searching APIs” where you will see “Finding API” listed.
5. You will find helpful links for Overview, API Reference, and Release Notes. Click on API Reference (http://developer.ebay.com/Devzone/finding/CallRef/index.html).
6. You will be taken the the API Reference - Call Index page. For this project, we chose findItemsAdvanced, so that we can find items by minimum and maximum price. Click on the associated Samples link (http://developer.ebay.com/Devzone/finding/CallRef/findItemsAdvanced.html#Samples)
7. You are given a list of samples of what you can use this API for. We will use the Refining Results with Aspect Filters. Click on the link to take you directly to the sample call (http://developer.ebay.com/Devzone/finding/CallRef/findItemsAdvanced.html#sampleaspectFilter).
8. We need the code in URL format. Find the line that says “See also the non-wrapped version of this URL.” Click on the link (http://developer.ebay.com/Devzone/finding/CallRef/Samples/findItemsAdvanced_aspectFilter_in_url_xml.txt)
9. The link gives you the following: http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.12.0&SECURITY-APPNAME=YourAppID&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&itemFilter(0).name=MaxPrice&itemFilter(0).value=75.00&itemFilter(0).paramName=Currency&itemFilter(0).paramValue=USD&itemFilter(1).name=MinPrice&itemFilter(1).value=50.00&itemFilter(1).paramName=Currency&itemFilter(1).paramValue=USD&aspectFilter.aspectName=Megapixels&aspectFilter.aspectValueName=5.0+to+5.9+MP&paginationInput.entriesPerPage=2&categoryId=31388
10. Replace “YourAppID” with your ID from step 2. Replace the XML in RESPONSE-DATA-FORMAT with JSON. “CategoryId” can be replaced with “keywords,” depending on what you would like to call. Now, you have the basis of your JSON call.
11. Read through the API Reference Guide for more instructions on using the different parameters.


## Shashi

### Popover View and More Git

We wanted to show an enlarged view of the items in our collection view without directing the user to another view controller, so we got the idea of using a popover view from Instagram. It was challenging to create a popover segue from a dynamic collection view item, however I was able to figure it out after struggling a good amount of time. It was very exciting to integrate a tool that we haven’t still learned in class!

I worked on getting the segues to work with the data from the previous view controller(sender) as well as creating functions to organize data. We went through a lot of debugging to get the correct data in to our app. I also created the logo for our app with the ideas of my teammates. This turned out to be the most successful project I have worked on so far.

Another very important thing I learned from this project is how to deal with git merge conflicts. I can say I am more confident on git now than ever!
