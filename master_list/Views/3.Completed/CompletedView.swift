// 20250605
// CompletedView

import SwiftUI
import SwiftData

struct CompletedView: View {
    
    // MARK: - VARIABLES
    @Environment(\.modelContext) private var context
    
//    // Querying all Items
//    @Query(sort: [SortDescriptor(\Item.sortOrder), SortDescriptor(\Item.completedAt, order: .reverse)]) private var allItemsList:[Item]
//    
//    // Filtering only Completed items (isCompleted = true)
//    private var completedItemsList: [Item] {
//        allItemsList.filter { $0.isCompleted }
//    }
    
    @Query(
        filter: #Predicate<Item> { $0.isCompleted == true },
        sort: [SortDescriptor(\Item.completedAt, order: .reverse)]
    ) private var completedItemsList: [Item]

    // MARK: - BODY
    var body: some View {
        NavigationView {
            List {
                if completedItemsList.isEmpty {
                    ContentUnavailableView {
                        Label("No Completed Items", systemImage: "checklist")
                    } description: {
                        Text("Complete some items to see them here!")
                    }
                } else {
                    ForEach(completedItemsList) { item in
                        CompletedItemView(item: item)
                    }
                    .onDelete(perform: deleteItem) // Swift handles the index (no need to pass in)

                }
            }
            .navigationTitle("Completed Items")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - FUNCTIONS
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(completedItemsList[index])
            }
            
            // Save Changes
            try? context.save()
        }
    }
}
