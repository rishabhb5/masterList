//
//  CompletedItemView.swift
//  master_list
//
//  Created by rishabh b on 6/8/25.
//

import SwiftUI
import SwiftData

struct CompletedItemView: View {

    // MARK: - Variables
    @Environment(\.modelContext) private var context
    let item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    // MARK: - Body
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
        } /* HStack */
    } /* body View*/
} /* CompletedItemView */
