//
//  InboxCell.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/9.
//

import SwiftUI

struct InboxListCell: View {
    
    var message: InboxMessage
    
    var body: some View {
        HStack {
            RemoteImageView(url: message.thumbnail_src ?? "",
                            placeholder: .inbox)
                .frame(width: 95, height: 95)
            
            VStack(alignment: .leading) {
                Text(message.title)
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(message.content ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Text(message.publish_time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 3)
        }
        .frame(height: 100)
        .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 5))
        .overlay(alignment: .topLeading) {
            if !message.read {
                Image("readDot_icon")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .padding(.top, 10)
                    .padding(.leading, 5)
            }
        }
    }
}

#Preview {
    InboxListCell(message: InboxMessage(id: 0, publish_time: "This is the inbox message time", title: "This is the inbox message title", content: "This is the inbox message content", image_src: nil, thumbnail_src: nil, link_type: "", link_related_id: "", external_url: "", read: false))
}
