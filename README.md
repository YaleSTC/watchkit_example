# WatchKit Example

## Functionality

This iPhone and Apple Watch app connects to the [Yale transit API](https://developers.yale.edu/documentation/CampusLife/transloc) to display bus arrival times at nearby stops. Run the iPhone app to query the API; keep the app in the foreground to query the API every minute. A list of buses will be displayed on the Apple Watch app.

## How It Works

The app runs on an iPhone and paired Apple Watch.

There are three parts to an Apple Watch project:

1. The iPhone App, in this project called **WatchKit Example**. This contains the code for the companion iOS app.
2. The WatchKit App, in this project called **WatchKit Example WatchKit App**. This contains the user interface for the watch app.
3. The WatchKit Extension, in this project called **WatchKit Example WatchKit Extension**. This contains the logic for the watch app and the connection to the iOS app.

The `TransitAPIModule` singleton makes API requests. The `LocationModule` singleton tracks the user's location. The `ViewController` class initiates the API requests and sends the data to the watch app through an *Application Context*. The `ScheduleInterfaceController` receives this data, parses it, and instructs the user interface to display it.

## To Run the App

The app is written in Swift 3 and targets watchOS 3. You must have a Mac with the latest version of Xcode installed. Clone this repo to get the code, and open the `.xcodeproj` file. The app will run in the simulator or on a connected device.
