//
//  ItemRowView.swift
//  master_list
//
//  Created by rishabh b on 6/5/25.
//

import SwiftUI
import SwiftData

struct ActiveItemView: View {
    
    // MARK: - VARIABLES
    @Environment(\.modelContext) private var context
    let item: Item
    let showDragHandle: Bool
    
    init(item: Item, showDragHandle: Bool = true) {
        self.item = item
        self.showDragHandle = showDragHandle
    }
    
    // MARK: - BODY
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .strikethrough(item.isCompleted)
                    .foregroundColor(item.isCompleted ? .gray : .primary)
                    .font(.system(size: 16, weight: .medium))
                
                HStack(spacing: 4) {
                    Image(systemName: item.category.icon)
                        .font(.system(size: 12))
                        .foregroundColor(item.category.color)
                    
                    Text(item.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(item.category.color)
                }
            } /* VStack */
            
            Spacer()
            
            // Conditionally show drag handle
            if showDragHandle {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                    .frame(width: 20)
            }
            
            Spacer()
        } /* HStack */
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                   // Swipe from right edge to complete/uncomplete
                   Button {
                       toggleCompletion()
                   } label: {
                       Label(
                           "Complete",
                           systemImage: "checkmark.circle"
                       )
                   }
                   .tint(.green)
               }
    }
    
    // MARK: - FUNCTIONS
    private func toggleCompletion() {
        withAnimation {
            item.isCompleted.toggle()
            try? context.save()
        }
    }
}
