//
//  AllListView.swift
//  master_list
//
//  Created by rishabh b on 6/5/25.
//

import SwiftUI
import SwiftData

struct ActiveView: View {
    
    // Insert, Delete, Save (CRUD operations)
    @Environment(\.modelContext) private var context
    
    // itemList: Fetches data from the DB, updates UI reactively when data changes
    @Query(sort: [SortDescriptor(\Item.sortOrder),
                  SortDescriptor(\Item.createdAt, order:.reverse)]) private var allItemsList:[Item]
    
    // Filter Active Items (inComplete) in computed property
    private var activeItemsList: [Item] {
        allItemsList.filter { !$0.isCompleted}
    }
    
    @State private var showingAddSheet: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                
                if activeItemsList.isEmpty {
                    ContentUnavailableView {
                        Label("No Active Items", systemImage: "checklist")
                    } description: {
                        Text("Click '+' to add a new item or check check Completed tab")
                    }
                } else {
                    ForEach(activeItemsList) { item in
                        ItemView(item: item)
                    }
                    .onDelete(perform: deleteItem) // Swift handles the index (no need to pass in)
                    .onMove(perform: moveItem) // Swift handles the index (no need to pass in)
                }
                
            }
            .navigationTitle("Master List - All Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {showingAddSheet = true}) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) { // automatically present when showingAddSheet's state changes
                AddItemView()
            }
        } /*NavigationView*/
    } /* body View */
    
    // Functions
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(activeItemsList[index])
            }
            
            // Save Changes
            try? context.save()
        }
    }
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        var updatedItems = Array(activeItemsList)
        updatedItems.move(fromOffsets: source, toOffset: destination)
        
        // Update sort order for all items
        for (index, item) in updatedItems.enumerated() {
            item.sortOrder = index
        }
        
        // Save Changes
        do {
            try context.save()
        } catch {
            print("Failed to save reordered items: \(error)")
        }
        
    }
    
} /* ActiveView View*/



//#Preview {
//    ActiveView()
//}
