//
//  MoreCollectionsListView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import SwiftUI

struct MoreCollectionsListView: View {
    
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Text("MoreCollectionsListView")
            }
            .modifier(NavigationModifier())
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationBarBackButtonHidden()
        }
        
    }
}

#Preview {
    MoreCollectionsListView()
}
