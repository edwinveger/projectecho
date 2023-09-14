import SwiftUI

public struct EstimoteView: View {

    public init() { }

    public var body: some View {
        NavigationView {
            Text("hey")
                .navigationTitle("EstimoteView")
        }
        .tabItem {
            Label("Estimote", systemImage: "wifi.circle")
        }
    }
}

struct EstimoteView_Previews: PreviewProvider {

    static var previews: some View {
        TabView {
            EstimoteView()

            Text("Item 2")
                .tabItem {
                    Label("Item 2", systemImage: "infinity.circle")
                }
        }
    }
}

