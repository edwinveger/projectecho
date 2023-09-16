//
//  ProjectEchoApp.swift
//  ProjectEcho
//
//  Created by Edwin on 14/09/2023.
//

import AppData
// import AppFeature
import SwiftUI

@main
struct ProjectEchoApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {

    let roomInstanceService: RoomInstanceService

    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

    }
}
