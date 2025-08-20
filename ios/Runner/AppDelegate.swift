/* 
   File: ios/Runner/AppDelegate.swift
   Replace your existing AppDelegate.swift with this:
*/

import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Get your Google Maps API key from Google Cloud Console
    // Enable "Maps SDK for iOS" API in your Google Cloud project
    // Replace "YOUR_API_KEY_HERE" with your actual API key
    GMSServices.provideAPIKey("AIzaSyAZA8e1OUrbXXyuaWucnuFM6X69QXLMIcw")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

/*
IMPORTANT STEPS TO GET YOUR API KEY:

1. Go to https://console.cloud.google.com/
2. Select your project or create a new one
3. Enable "Maps SDK for iOS" API
4. Go to Credentials → Create Credentials → API Key
5. Copy the API key and replace "YOUR_IOS_GOOGLE_MAPS_API_KEY_HERE" above
6. (Optional) Restrict the API key to iOS apps for security

Example:
GMSServices.provideAPIKey("AIzaSyC1234567890abcdefghijklmnop")
*/