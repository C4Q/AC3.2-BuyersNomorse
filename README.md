# Project: Buyers Nomorse

An app that does stuff related to price comparison.

## Erica

### Facebook Integration

Goal: Allow users to sign-in and share interesting findings with friends.

#### Part 1: Configuring the Facebook SDK for iOS 

* SDK == Software Developer Kit
* A set of frameworks that allow us to _“easily”_ integrate our apps with Facebook
//What are frameworks?
* “Link to Getting Started with the Facebook SDK for iOS” == (https://developers.facebook.com/docs/ios/getting-started/)


## Sabrina

### Going through eBay's API

My biggest contribution to this project was figuring our eBay’s JSON data. EBay has many different data sets, depending on which API the user calls.  We started this project with one set of JSON data that was easily found (FindPopularItems) - but it did not contain the information/parameters we needed (the ability to filter by min and max prices). I was insistent that we continue looking for the right JSON data instead of changing our project, because I knew that if the function could be performed on eBay’s website, we should be able to find data on it.

With research, we found the API call we wanted (findItemsAdvanced) - but it was difficult to find the data in JSON format. It took a whole day’s time of reading through eBay’s API Reference Guide to find the necessary data. The JSON data is hidden under URL format. In the API Reference Guide must click the link that says “See also the non-wrapped version of this URL.” Then, change the parameter RESPONSE-DATA-FORMAT to JSON instead of XML.

I found that going through eBay’ data was not straightforward. It took intuition. For example, the reference guide lists parameters for searching by min and max prices, but not on how to search for one without the other. (Hint: It’s not as simple as removing the unnecessary parameter. The parameter name has to change slightly as well.)

I learned that outside research may be just as helpful as an API guide (such as, finding out the  category ID’s of popular eBay items - for these numbers change frequently). This project also reinforced a lot of previous lessons - such as using UITextField and delegates, as well as error parsing. I practiced initializing computed class variables, as opposed to just using stored properties.

I learned to collaborate and communicate with others in using git, and in general. I learned to read through other people’s code and storyboard, and to learn from their programming and stylistic choices. I was lucky to work on this project with very talented and creative partners. 

## Shashi

### Popover View and More Git

We wanted to show an enlarged view of the items in our collection view without directing the user to another view controller, so we got the idea of using a popover view from Instagram. It was challenging to create a popover segue from a dynamic collection view item, however I was able to figure it out after struggling a good amount of time. It was very exciting to integrate a tool that we haven’t still learned in class!

I worked on getting the segues to work with the data from the previous view controller(sender) as well as creating functions to organize data. We went through a lot of debugging to get the correct data in to our app. I also created the logo for our app with the ideas of my teammates. This turned out to be the most successful project I have worked on so far.

Another very important thing I learned from this project is how to deal with git merge conflicts. I can say I am more confident on git now than ever!