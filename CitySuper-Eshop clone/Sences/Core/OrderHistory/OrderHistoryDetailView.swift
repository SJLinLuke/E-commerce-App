//
//  OrderHistoryDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/25.
//

import SwiftUI
import MobileBuySDK

struct OrderHistoryDetailView: View {
    
    let orderHistory: OrderViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    OrderHistoryCell1()
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                    
                    OrderHistoryDetailSectionHeader(title: "Order Detail")
                    
                    VStack {
                        OrderHistoryProductsView(lineItems: orderHistory.lineItems)
                        
                        VStack(spacing: 7) {
                            SeperateLineView()
                            
                            OrderHistoryDetailTextItem(leadingText: "Item Subtotal", trailingText: "$400.00")
                            
                            OrderHistoryDetailTextItem(leadingText: "PORK10  / \nVC100 / \nSHIPFREE", trailingText: "-$140.00")
                                .lineSpacing(7)
                            
                            OrderHistoryDetailTextItem(leadingText: "Shipping charges", trailingText: "-$0.00")
                            
                            SeperateLineView()
                        }
                        
                        OrderHistoryDetailTextItem(leadingText: "Total", trailingText: "$260.00")
                            .padding(.vertical, 5)

                    }
                    .padding(.horizontal, 5)
                    
                    OrderHistoryDetailSectionHeader(title: "Pickup")
                    
                    VStack(spacing: 5) {
                       
                        OrderHistoryDetailTextItem(leadingText: "Pickup Date", trailingText: "2024/05/26")
                        
                        OrderHistoryDetailTextItem(alignment: .top, leadingText: "Pickup Store", trailingText: "city'super 國際金融中心分店 Citysiper,\n國際金融中心商場一樓1041-1049號舖,")

                    }
                    .padding(.horizontal, 5)
                    
                    OrderHistoryDetailSectionHeader(title: "Note")
                    
                    HStack {
                        Text("note")
                            .frame(height: 100)
                        Spacer()
                    }
                    .padding(.horizontal, 5)
                    
                    OrderHistoryDetailSectionHeader(title: "Payment")

                    HStack {
                        Text("visa ending 4242")
                        Spacer()
                    }
                    .padding(.horizontal, 5)
                    
                    SeperateLineView()
                        
                    Button {
                        
                    } label: {
                         ThemeButton(title: "Re-order")
                    }
                }
                .modifier(NavigationModifier(title: "Order History", isHideCollectionsList: true, isHideShoppingCart: true))
            }
        }
    }
}

//#Preview {
//    OrderHistoryDetailView()
//}

struct OrderHistoryDetailTextItem: View {
    
    var alignment: VerticalAlignment = .center
    let leadingText: String
    let trailingText: String
    
    var body: some View {
        HStack(alignment: alignment) {
            Text(leadingText)
            Spacer()
            Text(trailingText)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct OrderHistoryProductsView: View {
    
    let lineItems: [Storefront.OrderLineItem]
    
    var body: some View {
        LazyVGrid(columns: [GridItem()]){
            ForEach(lineItems.indices, id: \.self) { index in
                HStack(spacing: 8) {
                    RemoteImageView(url: lineItems[index].variant?.image?.url.absoluteString ?? "", placeholder: .common)
                        .frame(width: 130, height: 130)
                    
                    VStack(alignment: .leading) {
                        Text(lineItems[index].title)
                        Text("QTY: \(lineItems[index].quantity)")
                            .padding(.top, 5)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Text("$\(lineItems[index].originalTotalPrice.amount.formattedPrice)")
                        }
                    }
                }
            }
        }
    }
}

struct OrderHistoryDetailSectionHeader: View {
    
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
                .padding(.vertical)
                .padding(.leading, 5)
            
            Spacer()
        }
        .background(Color(hex: "F7F7F7"))
    }
}

struct OrderHistoryCell1: View {

    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                HStack {
                    Text("Order# 123")
                        .fontWeight(.bold)
                    Spacer()
                    Text("proccessing")
                        .fontWeight(.bold)
                        .foregroundColor(.themeGreen2)
                }
                
                Spacer()
                    .frame(height: 2)
                
                Text("2024/10/15")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Progress(height: 7,
                         figureTarget: 0.5,
                         color: .themeGreen2,
                         isAnimated: false)
                
                Text("VM.customLabelText(orderHistory)")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Spacer()
                    .frame(height: 30)
                
                Text("Amount: HK$100")
            }
            .padding(8)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .secondary, radius: 3, x: 1, y: 1)
        }
        .padding(.horizontal, -13)
        .padding(.bottom, 6.5)
        .listRowSeparator(.hidden, edges: .all)
    }
}
