//
//  PickupStoreTagsView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/30.
//

import SwiftUI

struct PickupStoreTagsView: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    let store: Locations
    
    var body: some View {
        HStack(spacing: 10) {
            
            var isSelected: Bool = store == cartEnv.currentSelectedStore
            
            VStack {
                Circle()
                    .frame(width: 15)
                    .foregroundColor(.clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.secondary, lineWidth: 0.5)
                        if isSelected {
                            Circle()
                                .frame(width: 5.5)
                                .foregroundColor(.themeDarkGreen)
                        }
                    }
                    .shadow(radius: 10)
                    .padding(.leading, 10)
                    .padding(.top, 10)
                
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(store.name ?? "")
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 3, trailing: 0))
                        .bold()
                        .foregroundColor(isSelected ? .themeDarkGreen : Color(hex: "666666"))
                    
                    Text("Address: \(store.address1 ?? "") \(store.address2 ?? "")")
                        .lineLimit(2)
                        .foregroundColor(isSelected ? .black : Color(hex: "666666"))
                    
                    Text("Hours: \(store.open_at ?? "")-\(store.close_at ?? "")")
                        .foregroundColor(Color(hex: "666666"))
                        .padding(.bottom, 10)
                }
                .frame(width: 250, alignment: .leading)
                .font(.callout)
                .fontWeight(.regular)
                
                Spacer()
            }
        }
    }
}

#Preview {
    PickupStoreTagsView(store: Locations(province: "", city: "Hong Kong", address1: "Address1", address2: "Address2", country: "Hong Kong", shopify_location_id: 0, name: "Tokyo Store", open_at: "10:00am", close_at: "18:00pm", preparation_time: 0, available_dates: []))
        .environmentObject(CartEnvironment())
}
