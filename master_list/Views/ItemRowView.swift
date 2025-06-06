//
//  ItemRowView.swift
//  master_list
//
//  Created by rishabh b on 6/5/25.
//

import SwiftUI

struct ItemRowView: View {
    let item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    var body: some View {
        Text("Item Row")
    }
}

//#Preview {
//    ItemRowView(item: <#Item#>)
//}
