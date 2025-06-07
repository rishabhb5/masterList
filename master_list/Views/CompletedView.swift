//
//  CompletedListView.swift
//  master_list
//
//  Created by rishabh b on 6/5/25.
//

import SwiftUI
import SwiftData

struct CompletedView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: [SortDescriptor(\Item.sortOrder), SortDescriptor(\Item.createdAt, order: .reverse)]) private var allItemsList:[Item]
    
    private var completedItemsList: [Item] {
        allItemsList.filter { $0.isCompleted }
    }
    
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
                    ItemView(item: item)
                }
            }
        }
    }
}

//#Preview {
//    CompletedView()
//}
