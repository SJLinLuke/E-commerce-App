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
                    OrderHistoryCell(orderHistory: orderHistory)
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: -5, trailing: 20))
                    
                    OrderHistoryDetailSectionHeader(title: "Order Detail")
                    
                    VStack {
                        OrderHistoryProductsView(lineItems: orderHistory.lineItems)
                        
                        VStack(spacing: 7) {
                            SeperateLineView()
                            
                            OrderHistoryDetailTextItem(leadingText: "Items Subtotal", trailingText: "$\(orderHistory.lineItemsTotalPrice.formattedPrice)")
                            
                            let totalDiscount = orderHistory.lineItemsTotalPrice - orderHistory.totalPrice + orderHistory.totalShippingPrice
                            OrderHistoryDetailTextItem(leadingText: orderHistory.discountApplication?.textViewFormat ?? "", 
                                                       trailingText: "-$\(totalDiscount.formattedPrice)")
                                .lineSpacing(7)
                            
                            OrderHistoryDetailTextItem(leadingText: "Shipping charges", trailingText: "$\(orderHistory.totalShippingPrice.formattedPrice)")
                            
                            SeperateLineView()
                        }
                        
                        OrderHistoryDetailTextItem(font: .system(size: 18), leadingText: "Total", trailingText: "$\(orderHistory.totalPrice.formattedPrice)")
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
                            .fontWeight(.bold)

                    }
                    .padding(.horizontal, 5)
                    
                    OrderHistoryDetailSectionHeader(title: orderHistory.orderMethodInfo.orderMethod)
                    
                    VStack(spacing: 8) {
                       
                        OrderHistoryDetailTextItem(leadingText: "\(orderHistory.orderMethodInfo.orderMethod) Date",
                                                   trailingText: orderHistory.orderMethodInfo.orderCompleteDate)
                        
                        OrderHistoryDetailTextItem(alignment: .top,
                                                   leadingText: orderHistory.orderMethodInfo.orderMethod == "Delivery" ? "Delivery Address" : "Pickup Store",
                                                   trailingText: orderHistory.shippingAddress?.fullAddress ?? "")

                    }
                    .padding(.horizontal, 5)
                    
                    OrderHistoryDetailSectionHeader(title: "Note")
                    
                    HStack {
                        Text(orderHistory.orderInfo.note ?? "")
                            .frame(height: 100)
                        Spacer()
                    }
                    .padding(.horizontal, 5)
                    
                    OrderHistoryDetailSectionHeader(title: "Payment")
                    
                    var cardText: AttributedString {
                        var result: AttributedString = ""
                        if let payment_method = orderHistory.orderInfo.payment_method {
                            let brand = AttributedString("\(payment_method.card.brand) ")
                            let last4 = AttributedString(" \(payment_method.card.last4)")
                            var ending = AttributedString("ending")
                                ending.foregroundColor = .lightGray
                            
                            result = brand + ending + last4
                            return result
                        }
                        return result
                    }
                    
                    HStack {
                        Text(cardText)
                        Spacer()
                    }
                    .padding(.horizontal, 5)
                    
                    SeperateLineView()
                        
                    Button {
                        
                    } label: {
                         ThemeButton(title: "Re-order")
                    }
                    .padding(.vertical)
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
    
    var font: Font                   = .system(size: 16)
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
        .font(font)
    }
}

struct OrderHistoryProductsView: View {
    
    let lineItems: [Storefront.OrderLineItem]
    
    var body: some View {
        LazyVGrid(columns: [GridItem()]){
            ForEach(lineItems.indices, id: \.self) { index in
                HStack(spacing: 8) {
                    RemoteImageView(url: lineItems[index].variant?.image?.url.absoluteString ?? "",
                                    placeholder: .common)
                        .frame(width: 130, height: 130)
                    
                    VStack(alignment: .leading) {
                        Text(lineItems[index].title)
                            .fontWeight(.bold)
                            .lineLimit(3)
                        
                        Text("QTY: \(lineItems[index].quantity)")
                            .font(.subheadline)
                            .padding(.top, 2)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Text("$\(lineItems[index].originalTotalPrice.amount.formattedPrice)")
                                .foregroundColor(Color(hex: "E85321"))
                        }
                    }
                    .font(.subheadline)
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
