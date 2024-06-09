//
//  ShoppingCartView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import SwiftUI

struct ShoppingCartView: View {
    
    @EnvironmentObject private var userEnv: UserEnviroment
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    @Binding var isShowingModal: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex:"F2F2F2")
                VStack {
                    
                    ShoppingHeaderView(cartItemsNum: cartEnv.lineItems.count)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem()], spacing: 1) {
                            ForEach(cartEnv.lineItems) { lineItem in
                                ShoppingCartProductsListCell(lineItem: lineItem)
                            }
                        }
                    }
                    .padding(.top, -8)
                    .padding(.bottom, -8)
                    
                    ShoppingCartInfoView()
                }
            }
            .overlay {
                if cartEnv.isLoading {
                    LoadingIndicatiorView()
                }
            }
            .task {
                cartEnv.fetchCheckout()
            }
            .navigationTitle("Shopping Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingModal = false
                    } label: {
                        Image("back_icon")
                    }
                }
            }
        }
    }
}

#Preview {
    ShoppingCartView(isShowingModal: .constant(true))
        .environmentObject(CartEnvironment())
}

struct ShoppingHeaderView: View {
    
    let cartItemsNum: Int
    
    var body: some View {
        HStack {
            var cartCountingNum: AttributedString {
                var result: AttributedString = ""
                var cart = AttributedString("Cart:")
                cart.foregroundColor = .secondary
                cart.font = .callout
                var countingNum = AttributedString("  \(cartItemsNum) items")
                countingNum.font = .system(.callout, weight: .heavy)
                countingNum.foregroundColor = .secondary
                
                result = cart + countingNum
                return result
            }
            
            Text(cartCountingNum)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Clean all")
                    .font(.callout)
                    .fontWeight(.heavy)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

struct ShoppingCartInfoView: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    var body: some View {
        VStack {
            
            CustomFormTextItem(leadingText: "SubTotal", 
                               trailingText: Currency.stringFrom(cartEnv.subTotal),
                               leadingColor: Color(hex: "777777"),
                               trailingFont: .bold)
            
            CustomFormTextItem(leadingText: cartEnv.discountApplication.textViewFormat,
                               trailingText: "-\(Currency.stringFrom(cartEnv.totalDiscount))",
                               leadingColor: Color(hex: "777777"),
                               trailingColor: Color(hex: "E85321"),
                               alignment: .bottom)
            
            SeperateLineView(color: .commonBackGroundGray, height: 1.5)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text("Total")
                        .foregroundColor(Color(hex: "777777"))
                        .padding(.bottom, 5)
                    Text(Currency.stringFrom(cartEnv.totalPrice))
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    ThemeButton(title: "Checkout", font: .regular, width: 170, iconPath: "check_icon")
                }
            }
            .padding(.bottom, -10)
        }
        .padding()
        .background(.white)
        .overlay(alignment: .top) {
            SeperateLineView(color: .commonBackGroundGray, height: 1.5)
        }
    }
}

struct ShoppingCartProductsListCell: View {
    
    let lineItem: LineItemViewModel
    
    @State var quantity: Int
    
    init(lineItem: LineItemViewModel) {
        self.lineItem = lineItem
        self.quantity = lineItem.quantity
    }
    
    var body: some View {
        
        HStack {
            RemoteImageView(url: lineItem.variant?.image?.url.absoluteString ?? "", placeholder: .common)
                .frame(width: 130, height: 130)
            
            VStack(alignment: .leading) {
                Text(lineItem.title)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                Spacer()
                
                QuantitySelectorView(quantity: $quantity, inventoryQuantity: Int(lineItem.variant?.quantityAvailable ?? 0))
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(Currency.stringFrom(lineItem.individualPrice))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image("trash_can_icon")
                }
            }
            .padding(.trailing, 5)
            .padding(.leading)
        }
        .font(.subheadline)
        .padding(8)
        .background(.white)
        .padding(.horizontal, 10)
    }
}
