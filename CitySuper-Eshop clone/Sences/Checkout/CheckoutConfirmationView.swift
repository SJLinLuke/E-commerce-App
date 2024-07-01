//
//  CheckoutConfirmationView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/30.
//

import SwiftUI

struct CheckoutConfirmationView: View {
    
    @StateObject var VM: CheckoutConfirmationViewModel
    
    @State var isShowCoupon: Bool = false
    
    init(checkout: CheckoutViewModel) {
        self._VM = StateObject(wrappedValue: CheckoutConfirmationViewModel(checkout: checkout))
    }
    
    var body: some View {
            ScrollView {
                VStack {
                    OrderHistoryDetailSectionHeader(title: "Order Detail")
                    
//                    OrderHistoryDetailProductsListView(lineItems: VM.lineItems)
                    
                    LazyVGrid(columns: [GridItem()]){
                        ForEach(VM.lineItems.indices, id: \.self) { index in
                            HStack(spacing: 8) {
                                RemoteImageView(url: VM.lineItems[index].variant?.image?.absoluteString ?? "",
                                                placeholder: .common)
                                    .frame(width: 130, height: 130)
                                
                                VStack(alignment: .leading) {
                                    Text(VM.lineItems[index].title)
                                        .fontWeight(.bold)
                                        .lineLimit(3)
                                    
                                    Text("QTY: \(VM.lineItems[index].quantity)")
                                        .font(.subheadline)
                                        .padding(.top, 2)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text(Currency.stringFrom(VM.lineItems[index].individualPrice))
                                            .padding(.trailing, 10)
                                    }
                                }
                                .font(.subheadline)
                            }
                            
                            SeperateLineView()
                        }
                    }
                    
                    VStack {
                        SeperateLineView()
                        
                        HStack(alignment: .center) {
                            Label(
                                title: { Text("Apply Discount") },
                                icon: {
                                    Image("coupon_icon")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                            )
                            
                            Spacer()
                            
                            Button {
                                isShowCoupon.toggle()
                            } label: { Text("Edit") }
                        }
                        .foregroundColor(.themeDarkGreen)
                        
                        SeperateLineView()
                        
                        CustomFormTextItem(
                            leadingText: "Items Subtotal",
                            trailingText: Currency.stringFrom(VM.subTotal))
                        
                        CustomFormTextItem(
                            leadingText: "Shipping charges",
                            trailingText: Currency.stringFrom(VM.shippingPrice))
                        
                        SeperateLineView()
                        
                        CustomFormTextItem(leadingText: "Total",
                                           trailingText: Currency.stringFrom(VM.totalPrice),
                                           leadingFont: .bold,
                                           trailingFont: .bold,
                                           font: .system(size: 18))
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
                    }
                    .padding(.horizontal, 10)
                    
                    OrderHistoryDetailSectionHeader(title: "Delivery")
                    
                    VStack(spacing: 8) {
                       
                        CustomFormTextItem(leadingText: "Delivery Date",
                                           trailingText: "2024/07/02")
                        
                        CustomFormTextItem(leadingText: "Delivery Address",
                                           trailingText: "Jason Wong,\nidkidk,\n99999991111",
                                           alignment: .top)
                    }
                    .padding(.horizontal, 10)
                    
                    OrderHistoryDetailSectionHeader(title: "Note")
                    
                    VStack {
                        HStack {
                            Text("Remark")
                                .foregroundColor(Color(hex: "D2D2D2"))
                                .font(.callout)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 100 ,maxHeight:  100, alignment: .top)
                        .padding(.horizontal, 5)
                        
                        Spacer()
                    }
                    
                    OrderHistoryDetailSectionHeader(title: "Payment", buttonTitle: "Change", action: {
                        print("chenge")
                    })
                    
                    var cardText: AttributedString {
                        var result: AttributedString = "Visa ending 4242"
//                        if let payment_method = orderHistory.orderInfo.payment_method {
//                            let brand = AttributedString("\(payment_method.card.brand) ")
//                            let last4 = AttributedString(" \(payment_method.card.last4)")
//                            var ending = AttributedString("ending")
//                                ending.foregroundColor = .lightGray
//                            
//                            result = brand + ending + last4
//                            return result
//                        }
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
                        ThemeButton(title: "Pay", font: .title3)
                    }
                    .padding(.top)

                }
            }
            .modifier(NavigationModifier(navTilte: "Order Detail", isHideCollectionsList: true, isHideShoppingCart: true))
            .navigationDestination(isPresented: $isShowCoupon) {
                CouponListView(isRedeemable: true)
            }
    }
}

//#Preview {
//    CheckoutConfirmationView()
//}
