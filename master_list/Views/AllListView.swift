//
//  AllListView.swift
//  master_list
//
//  Created by rishabh b on 6/5/25.
//

import SwiftUI
import SwiftData

struct AllListView: View {
    
    // Insert, Delete, Save (CRUD operations)
    @Environment(\.modelContext) private var context
    
    // itemList: Fetches data from the DB, updates UI reactively when data changes
    @Query(sort: [SortDescriptor(\Item.sortOrder),
                  SortDescriptor(\Item.createdAt, order:.reverse)]) private var itemList:[Item]
    
    @State private var showingAddSheet: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(itemList) { item in
                    ItemRowView(item: item)
                }
                .onDelete(perform: deleteItem) // Swift handles the index (no need to pass in)
                //.onMove(perform: moveItems) // Swift handles the index (no need to pass in)
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
    
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(itemList[index])
            }
            
            try? context.save()
        }
    }
} /* AllListView View*/



//#Preview {
//    AllListView()
//}
