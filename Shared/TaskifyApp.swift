//
//  TaskifyApp.swift
//  Shared
//
//  Created by Dalal Gheshiyan on 05/09/2022.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct TaskifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)var delegat
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
