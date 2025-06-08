//
//  CompletedListView.swift
//  master_list
//
//  Created by rishabh b on 6/5/25.
//

import SwiftUI
import SwiftData

struct CompletedView: View {
    
    // MARK: - VARIABLES
    @Environment(\.modelContext) private var context
    
    // Querying all Items
    @Query(sort: [SortDescriptor(\Item.sortOrder), SortDescriptor(\Item.createdAt, order: .reverse)]) private var allItemsList:[Item]
    
    // Filtering only Completed items (isCompleted = true)
    private var completedItemsList: [Item] {
        allItemsList.filter { $0.isCompleted }
    }
    
    // MARK: - BODY
    var body: some View {
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
