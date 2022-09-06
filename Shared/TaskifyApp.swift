//
//  TaskifyApp.swift
//  Shared
//
//  Created by Dalal Gheshiyan on 05/09/2022.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
      let db = Firestore.firestore()
      
      // Add a new document with a generated ID
      var ref: DocumentReference? = nil
      ref = db.collection("users").addDocument(data: [
          "first": "Ada",
          "last": "Lovelace",
          "born": 1815
      ]) { err in
          if let err = err {
              print("Error adding document: \(err)")
          } else {
              print("Document added with ID: \(ref!.documentID)")
          }
      }
      
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
