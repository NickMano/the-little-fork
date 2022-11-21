![coverage](https://img.shields.io/badge/coverage-67%25-green)

# The Little Fork

The Little Fork is a swift project for view a list of restaurants.

## Requirements

Xcode 14.1 is recommended.

## Installation

Clone the reposotiry and open `TheLittleFork.xcodeproj` 👏

## Screenshots

### Main View 

<p float="left">
  <img src="https://i.imgur.com/g42gHKz.png" width="428" height="926" />
  <img src="https://i.imgur.com/TrbRD6Q.png" width="428" height="926" />
</p>

## Arquitecture

* This project uses MVP as a main arquitecture pattern considering the size of the application. I make the view controller only to the lifecycle and navigation (in this case we don't have other views).
* For persistance, the app is using UserDefaults.

## Decisions

* I create a Network Manager instead of use a dependecy (like Alamofire) to keep simple and lightweight the proyect.
* I add support to features of iOS 15 on network layer to make more easier the update on one of two years when iOS 15 is the recommended minimum. 
* To save the favorites I save an array of the restaurants' uuid. I plan to save the entire structure to be independent of the restaurant service but I think that the best thing in the future would be to have an endpoint.

## Dependecies

This project use Swift Package Manager 

* SketchKit - to simplify the constraints
* SwiftLint - to keep the good practices
* SnapshotTesting - to make snapshot testing

## Testing

* This project have Unit testing and Snapshot testing.
* The snapshots have been run on iPhone 12 Pro Max. You can see the snapshots [here](Snapshots.md)
