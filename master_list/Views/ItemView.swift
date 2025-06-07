//
//  ItemRowView.swift
//  master_list
//
//  Created by rishabh b on 6/5/25.
//

import SwiftUI
import SwiftData

struct ItemView: View {
    @Environment(\.modelContext) private var context
    let item: Item
    let showDragHandle: Bool
    
    init(item: Item, showDragHandle: Bool = true) {
        self.item = item
        self.showDragHandle = showDragHandle
    }
    
    var body: some View {
        HStack(spacing: 12) {
          
            
            Button(action: toggleCompletion) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .gray)
                    .font(.system(size: 20))
            }
            .buttonStyle(PlainButtonStyle())
            
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
        .onTapGesture {
            toggleCompletion()
        }
    }
    
    private func toggleCompletion() {
        withAnimation {
            item.isCompleted.toggle()
            try? context.save()
        }
    }
}

//#Preview {
//    ItemRowView(item: <#Item#>)
//}
