//
//  MoreCollectionListHeaderView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/15.
//

import SwiftUI

struct MoreCollectionListHeaderView: View {
    
    @StateObject private var VM = MoreCollectionsListViewModel.shared
    
    var body: some View {
        HStack {
            Text("ALL")
                .onTapGesture {
                    VM.currentSub = nil
                    VM.subHistory.removeAll()
                }
                .padding(.leading, 8)
            
            ForEach(VM.subHistory, id: \.self) { sub in
                HStack {
                    Image("arrow_icon")
                    
                    Text(sub.title)
                        .frame(maxWidth: 90)
                        .lineLimit(2)
                        .fixedSize()
                        .foregroundColor(sub.title == VM.currentSub?.title ? .themeGreen : .black)
                        .onTapGesture {
                            if let index = VM.subHistory.firstIndex(of: sub) {
                                VM.subHistory = Array(VM.subHistory.prefix(index + 1))
                                    }
                            VM.currentSub = sub
                        }
                }
            }
            
            Spacer()
        }
        .frame(height: 55)
        .background(Color(hex:"E5E5E9"))
        .font(.system(size: 12))
        .fontWeight(.bold)
        .padding(.top, 1)
    }
}

#Preview {
    MoreCollectionListHeaderView()
}
