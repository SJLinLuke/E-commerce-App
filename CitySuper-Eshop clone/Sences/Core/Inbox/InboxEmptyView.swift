//
//  InboxEmptyView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/17.
//

import SwiftUI

struct InboxEmptyView: View {
    var body: some View {
        VStack {
            Image("tab_inbox")
                .resizable()
                .frame(width: 40, height: 40)
            
            Text("You do not have any message now")
                .font(.title3)
                .padding(.top, 40)
            
            Spacer()
                .frame(height: 270)
        }
    }
}

#Preview {
    InboxEmptyView()
}
