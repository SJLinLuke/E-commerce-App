//
//  OrderHistoryDetailView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/25.
//

import SwiftUI
import MobileBuySDK

struct OrderHistoryDetailView: View {
    
    @StateObject var VM = OrderHistoryDetailViewModel()
        
    var orderHistory: OrderViewModel?
    var orderID     : String?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let orderHistory = VM.orderHistory {
                    VStack {
                        OrderHistoryCell(orderHistory: orderHistory)
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: -5, trailing: 20))
                        
                        OrderHistoryDetailSectionHeader(title: "Order Detail")
                        
                        VStack {
                            OrderHistoryDetailProductsView(lineItems: orderHistory.lineItems)
                            
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
            .overlay {
                if VM.isLoading {
                    LoadingIndicatiorView()
                }
            }
            .onAppear {
                if let orderHistory = self.orderHistory {
                    VM.selectedOrderHistory(orderHistory)
                }
                
                if let orderID = self.orderID {
                    VM.fetchOrder(orderID: orderID)
                }
            }
        }
    }
}

//#Preview {
//    OrderHistoryDetailView()
//}

