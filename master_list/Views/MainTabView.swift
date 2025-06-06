//  20250605
// Main View

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            AllListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("All")
                }
            
            CompletedListView()
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Completed")
                }
        }
    }
}

#Preview {
    MainTabView()
}
