//
//  AddItemView.swift
//  master_list
//
//  Created by rishabh b on 6/5/25.
//

import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var itemTitle = ""
    @State private var selectedCategory: ItemCategory = .personal
    
    private var canSave: Bool {
        !itemTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    @Query private var existingItems: [Item] // queries all items in the DB
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Todo Item")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        // User Input - modifies @State var itemTitle
                        TextField("Enter Item", text: $itemTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onSubmit {
                                if canSave {
                                    saveItem()
                                }
                            }
                        
                    } /* VStack */
                } /* VStack */
            } /* ScrollView */
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                }
            } /* toolbar */
        } /* NavigationView */
    } /* body View*/
    
    private func saveItem() {
        let newItem = Item(title: itemTitle, category: selectedCategory)
        
        // Set sort order to appear at top
        let maxSortOrder = existingItems.map { $0.sortOrder }.max() ?? 0
        newItem.sortOrder = maxSortOrder + 1
        
        context.insert(newItem)
        
        do {
            try context.save()
            dismiss()
        } catch {
            print("Failed to save item: \(error)")
        }
    }
   
} /* AddItemView View */

//#Preview {
//    AddItemView()
//}
