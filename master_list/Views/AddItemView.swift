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
    
    @Query private var existingItme: [Item] // queries all items in the DB
    
    var body: some View {
        Text("Add Item View")
    }
}

//#Preview {
//    AddItemView()
//}
