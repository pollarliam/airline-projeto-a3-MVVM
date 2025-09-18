import SwiftUI
import MapKit

struct MainView: View {
    @State private var sidebarSelection: String? = "overview"

    // A world-spanning camera position (center near 0,0 with a large span)
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
        )
    )

    var body: some View {
        NavigationSplitView {
            List(selection: $sidebarSelection) {
                Label("Overview", systemImage: "globe")
                    .tag("overview" as String?)
                Label("Places", systemImage: "mappin.and.ellipse")
                    .tag("places" as String?)
                Label("Settings", systemImage: "gear")
                    .tag("settings" as String?)
            }
            .navigationTitle("Sidebar")
        } detail: {
            ZStack {
                // Background full-window map
                Map(position: $cameraPosition)
                    .mapStyle(.standard)
                    .ignoresSafeArea()

                // Optional foreground overlay content placeholder
                VStack {
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
