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
// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
FBSDKAppEvents.activateApp()
}
```

  * At this point, the SDK is installed and configured. The easiest way to test this is by using the App Event, **Log App Activations**. We have already done this in the AppDelegate.swift file by calling the activateApp() method on the FBSDKAppEvents class. To check:
    * Compile & Run App
    * Go to the [Analytics for Apps Dashboard](https://www.facebook.com/analytics/373837896292654/) & select your app
    * From the menu on the left, select Activity -> Events


#### Part 2: Implementing Capabilites and/or Other App Events

**Example 1: Login with Facebook**

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

**Example 2: Add Sharing Capabilites**

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

**Example 3: Add Like Button**

Instead of using a tutorial, let's do this one straight from [Facebook's Developer Site](https://developers.facebook.com/docs/sharing/ios/like-button)

We're going to need this nifty [Objective-C -> Swift Converter](https://objectivec2swift.com/#/home/main)

#### Other Resources
* [Quickstart Link for Facebook SDK Integration] (https://developers.facebook.com/quickstarts/?platform=ios)
* [More Info on Facebook Analytics](https://developers.facebook.com/docs/analytics)


## Sabrina

### Going through eBay's API

My biggest contribution to this project was figuring our eBay’s JSON data. EBay has many different data sets, depending on which API the user calls.  We started this project with one set of JSON data that was easily found (FindPopularItems) - but it did not contain the information/parameters we needed (the ability to filter by min and max prices). I was insistent that we continue looking for the right JSON data instead of changing our project, because I knew that if the function could be performed on eBay’s website, we should be able to find data on it.

With research, we found the API call we wanted (findItemsAdvanced) - but it was difficult to find the data in JSON format. It took a whole day’s time of reading through eBay’s API Reference Guide to find the necessary data. The JSON data is hidden under URL format. In the API Reference Guide must click the link that says “See also the non-wrapped version of this URL.” Then, change the parameter RESPONSE-DATA-FORMAT to JSON instead of XML.

I found that going through eBay’ data was not straightforward. It took intuition. For example, the reference guide lists parameters for searching by min and max prices, but not on how to search for one without the other. (Hint: It’s not as simple as removing the unnecessary parameter. The parameter name has to change slightly as well.)

I learned that outside research may be just as helpful as an API guide (such as, finding out the  category ID’s of popular eBay items - for these numbers change frequently). This project also reinforced a lot of previous lessons - such as using UITextField and delegates, as well as error parsing. I practiced initializing computed class variables, as opposed to just using stored properties.

I learned to collaborate and communicate with others in using git, and in general. I learned to read through other people’s code and storyboard, and to learn from their programming and stylistic choices. I was lucky to work on this project with very talented and creative partners. 

## Shashi

### API endpoints

Sed ut perspiciatis unde omnis iste natus error sit voluptatem
accusantium doloremque laudantium, totam rem aperiam, eaque ipsa 
quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt 
explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit
aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. 
