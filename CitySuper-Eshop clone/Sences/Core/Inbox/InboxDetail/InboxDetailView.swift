//
//  InboxDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import SwiftUI

struct InboxDetailView: View {
    
    @StateObject var VM = InboxDetailViewModel()
    
    @State var htmlFrameHeight: CGFloat = .zero
    
    let notificationID: Int
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    if !VM.imageSrc.isEmpty {
                        RemoteImageView(url: VM.imageSrc, placeholder: .common)
                            .frame(height: 200)
                    }
                    
                    VStack {
                        HStack {
                            Text(VM.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        HStack {
                            Text(VM.publish_time)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .padding(.vertical)
                            Spacer()
                        }
                        
                        HTMLLoaderView(htmlFrameHeight: $htmlFrameHeight,
                                       htmlString: VM.htmlContent, source: Constants.inboxDetail_html_source)
                        .frame(height: htmlFrameHeight)
                        .padding(-10)
                        
                        if VM.isShowButton {
                            Button {
                                
                            } label: {
                                ThemeButton(title: VM.buttonTitle)
                            }
                            .padding(.vertical)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                }
                .navigationTitle("Inbox")
                .navigationBarTitleDisplayMode(.inline)
            }
            
        }
        .overlay {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        }
        .onAppear {
            VM.fetchInboxMessageDetail(id: notificationID)
        }
    }
}

#Preview {
    InboxDetailView(notificationID: 11323)
}
