//
//  ContentView.swift
//  ProjectEcho
//
//  Created by Edwin on 14/09/2023.
//

import AppFeature
import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            ArduinoBeaconView()
            EstimoteView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
