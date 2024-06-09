//
//  ShoppingCartView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import SwiftUI

struct ShoppingCartView: View {
    
    @Binding var isShowingModal: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex:"F2F2F2")
                VStack {
                    
                    ShoppingHeaderView()
                    
                    ScrollView {
                        // itemsCell
                        LazyVGrid(columns: [GridItem()], spacing: 1) {
                            ShoppingCartProductsListCell()
                            ShoppingCartProductsListCell()
                            ShoppingCartProductsListCell()
                            ShoppingCartProductsListCell()
                        }
                    }
                    .padding(.top, -8)
                    .padding(.bottom, -8)
                    
                    ShoppingCartInfoView()
                }
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
}

struct ShoppingHeaderView: View {
    var body: some View {
        HStack {
            var cartCountingNum: AttributedString {
                var result: AttributedString = ""
                var cart = AttributedString("Cart:")
                cart.foregroundColor = .secondary
                cart.font = .callout
                var countingNum = AttributedString("  5 items")
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
    var body: some View {
        VStack {
            
            CustomFormTextItem(leadingText: "SubTotal", 
                               trailingText: "$949.00",
                               leadingColor: Color(hex: "777777"),
                               trailingFont: .bold)
            
            CustomFormTextItem(leadingText: "super-e gold discount 3% off",
                               trailingText: "-$25.47",
                               leadingColor: Color(hex: "777777"),
                               trailingColor: Color(hex: "E85321"),
                               alignment: .bottom)
            
            SeperateLineView(color: .commonBackGroundGray, height: 1.5)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text("Total")
                        .foregroundColor(Color(hex: "777777"))
                        .padding(.bottom, 5)
                    Text("$923.53")
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
    
    @State var quantity: Int = 1
    
    var body: some View {
        
        HStack {
            Rectangle()
                .frame(width: 130, height: 130)
            
            VStack(alignment: .leading) {
                Text("lineItem.titlefdjskfjdlksjfjfkdsljkfsdfjdksljlkfd")
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                Spacer()
                
                QuantitySelectorView(quantity: $quantity, inventoryQuantity: 10)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(Currency.stringFrom(200.0))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image("trash_can_icon")
                }
            }
            .padding(.trailing, 5)
        }
        .font(.subheadline)
        .padding(8)
        .background(.white)
        .padding(.horizontal, 10)
    }
}
