//
//  SuggestionView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/20.
//

import SwiftUI

struct SuggestionView: View {
    
    @StateObject var VM = SuggestionViewModel.shared
    
    var body: some View {
        ScrollView {
            VStack {
                SearchHeaderView(title: "Recent Searches", buttonTitle: "Clean all") {
                    VM.historyKeywords = []
                    VM.clearHistoryKeyword()
                }
                
                SearchTagsView(keywords: VM.historyKeywords)
                
                SearchHeaderView(title: "Hot Keywords")
                
                SearchTagsView(keywords: VM.hotKeywords)
                
                SearchHeaderView(title: "Recommendation Collections")
                
                SearchRecommendationView(recommendationCollections: VM.recommendKeywords)
            }
            .task {
                VM.fetchSuggestion()
            }
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
        .background(Color(hex: "F2F2F2"))
        .padding(.top)
    }
}

#Preview {
    SuggestionView()
}
