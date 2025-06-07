//  20250605
// Main View

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            ActiveView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Active")
                }
            
            CompletedView()
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
