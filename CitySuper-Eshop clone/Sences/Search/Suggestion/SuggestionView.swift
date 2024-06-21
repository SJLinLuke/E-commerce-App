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
                SearchHeaderView(text: Text("Recent Searches"), buttonTitle: "Clean all") {
                    VM.historyKeywords = []
                    VM.clearHistoryKeyword()
                }
                
                SearchTagsView(keywords: VM.historyKeywords)
                
                SearchHeaderView(text: Text("Hot Keywords"))
                
                SearchTagsView(keywords: VM.hotKeywords)
                
                SearchHeaderView(text: Text("Recommendation Collections"))
                
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
        .frame(width: UIScreen.main.bounds.width)
    }
}

#Preview {
    SuggestionView()
}
