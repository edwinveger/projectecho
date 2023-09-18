//
//  ProjectEchoApp.swift
//  ProjectEcho
//
//  Created by Edwin on 14/09/2023.
//

import ComposableArchitecture
import SwiftUI

@main
struct ProjectEchoApp: App {

    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(initialState: Root.State()) {
                    Root()
                        .signpost()
                        ._printChanges()
                } withDependencies: {
                    $0.observeNearbyRooms = Environment.shared.bleRepository
                }
            )
        }
    }
}
