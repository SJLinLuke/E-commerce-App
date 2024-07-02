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
    
    init(checkout: CheckoutViewModel, checkedDate: String, selectedStore: Locations? = nil, address: AddressViewModel? = nil, checkoutMethod: CheckoutMethodsType) {
        self._VM = StateObject(wrappedValue: CheckoutConfirmationViewModel(
            checkout: checkout,
            checkedDate: checkedDate,
            selectedStore: selectedStore,
            address: address,
            checkoutMethod: checkoutMethod))
    }
    
    var body: some View {
            ScrollView {
                VStack {
                    OrderHistoryDetailSectionHeader(title: "Order Detail")
                    
                    OrderHistoryDetailProductsListView(lineItems_cart: VM.lineItems)
                        .padding(.horizontal, 10)
                    
                    VStack(spacing: 5) {
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
                    
                    OrderHistoryDetailSectionHeader(title: VM.isDelivery ? "Delivery" : "Pickup")
                    
                    VStack(spacing: 8) {
                        CustomFormTextItem(leadingText: VM.isDelivery ? "Delivery Date" : "Pickup Date",
                                           trailingText: VM.checkedDate.convertDataFormat(fromFormat: "yyyy-MM-dd",
                                                                                          toFormat: "yyyy/MM/dd"))
                        
                        CustomFormTextItem(leadingText: VM.isDelivery ? "Delivery Address" : "Pickup Store",
                                           trailingText: VM.shippingAddress,
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
                .onAppear {
                    VM.initCheckout()
                }
            }
            .overlay {
                if VM.isLoading {
                    LoadingIndicatiorView(backgroundDisable: true)
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
