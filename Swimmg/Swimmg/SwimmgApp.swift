import SwiftUI
import UIKit    // required for UIColor

@main
struct SwimmgApp: App {
    init() {
        // 1) Configure tab-bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(
            red: 10/255, green: 15/255, blue: 26/255, alpha: 1
        ) // your dark/navy background

        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }

        // 2) Set selected & unselected tint colors
        UITabBar.appearance().tintColor = UIColor(
            red: 64/255, green: 156/255, blue: 224/255, alpha: 1
        ) // metallic-blue for active tab
        UITabBar.appearance().unselectedItemTintColor = UIColor(
            white: 0.7, alpha: 1
        ) // silver-grey for inactive tabs
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()   // launches the three-tab container
        }
    }
}

struct MainTabView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            HomePage()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            BookingPage()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Book")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
                .tag(2)
        }
    }
}

