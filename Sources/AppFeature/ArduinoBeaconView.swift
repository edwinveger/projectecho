import SwiftUI

public struct ArduinoBeaconView: View {

    public init() { }

    public var body: some View {
        NavigationView {
            Text("hey")
                .navigationTitle("ArduinoBeaconView")
        }
        .tabItem {
            Label("Arduino", systemImage: "infinity.circle")
        }
    }
}

struct ArduinoBeaconView_Previews: PreviewProvider {

    static var previews: some View {
        TabView {
            ArduinoBeaconView()
            Text("Item 2")
                .tabItem {
                    Label("Item 2", systemImage: "wifi.circle")
                }
        }
    }
}

