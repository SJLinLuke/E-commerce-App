//
//  InboxDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import SwiftUI

struct InboxDetailView: View {
    
    @State var htmlFrameHeight: CGFloat = .zero
    
    let inboxMessage: InboxMessage
    
    var body: some View {
        NavigationStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(inboxMessage.title)
                    
                    Text(inboxMessage.publish_time.convertDataFormat(fromFormat: "yyyy/MM/dd hh:mm:ss", toFormat: "yyyy/MM/dd"))
                        .padding(.vertical)
                    
                    HTMLLoaderView(htmlFrameHeight: $htmlFrameHeight,
                                   htmlString: inboxMessage.content, source: Constants.inboxDetail_html_source)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Inbox")
            .navigationBarTitleDisplayMode(.inline)
            
            ThemeButton(title: "View Detail")
            
            Spacer()
        }
    }
}

#Preview {
    InboxDetailView(inboxMessage: InboxMessage(id: 1, publish_time: "", title: "TEST", content: "CONTENT", image_src: nil, thumbnail_src: nil, link_type: nil, link_related_id: nil, external_url: nil, read: false))
}
