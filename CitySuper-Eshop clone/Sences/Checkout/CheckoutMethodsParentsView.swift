//
//  CheckoutDelivery.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/24.
//

import SwiftUI

struct CheckoutMethodsParentsView: View {
    
    enum methodsType: String {
        case delivery = "Delivery"
        case pickup   = "Pickup"
    }
    
    @State private var currentMethod: methodsType = .delivery
    
    private let methods: [methodsType] = [.delivery, .pickup]
    
    private let width = UIScreen.main.bounds.width / 2
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(methods, id: \.self) { method in
                    
                    let isSelected: Bool = method == currentMethod
                    
                    Text(method.rawValue)
                        .frame(width: width, height: 75)
                        .fontWeight(isSelected ? .semibold : .regular)
                        .overlay(alignment: .bottom) {
                            if (isSelected) {
                                Spacer()
                                    .frame(height: 2)
                                    .background(Color(hex: "#46742D"))
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                self.currentMethod = method
                            }
                        }
                }
            }
            .background(Color(hex: "F2F2F2"))
            .padding()
            
            
            TabView(selection: $currentMethod) {
                ForEach(methods, id: \.self) { method in
                    switch currentMethod {
                    case .delivery:
                        delivery()
                    case .pickup:
                        pickup()
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(EdgeInsets(top: -15, leading: 0, bottom: -10, trailing: 0))
            
            Spacer()
        }
        .modifier(NavigationModifier(isHideCollectionsList: true, isHideShoppingCart: true))
    }
}

struct delivery: View {
    
    @State var firstName: String = ""
    @State var isSave: Bool = false
    let data = [1, 2]
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Text("Delivery Address")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.leading, 8)
                .padding(.vertical)
                
                ForEach(data, id: \.self) { index in
                    HStack(spacing: 10) {
                        Circle()
                            .frame(width: 15)
                            .foregroundColor(.clear)
                            .overlay {
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(.secondary, lineWidth: 0.5)
                                Circle()
                                    .frame(width: 5.5)
                                    .foregroundColor(.themeDarkGreen)
                            }
                            .shadow(radius: 10)
                            .padding(.leading, 10)
                        
                        HStack {
                            Text("TESTER USER\nNO ADDRESS TEST\n123458999")
                                .padding(8)
                                .lineSpacing(5)
                                .font(.callout)
                                .fontWeight(.regular)
                                .foregroundColor(Color(hex: "666666"))
                            
                            Spacer()
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(hex: "D2D2D2") ,lineWidth: 1)
                        }
                        .background(Color(hex: "F2F2F2"))
                        
                        
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                    if index == data.last {
                        HStack(spacing: 10) {
                            Circle()
                                .frame(width: 15)
                                .foregroundColor(.clear)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(.secondary, lineWidth: 0.5)
                                    Circle()
                                        .frame(width: 5.5)
                                        .foregroundColor(.themeDarkGreen)
                                }
                                .shadow(radius: 10)
                                .padding(.leading, 10)
                            
                            VStack {
                                CustomTextField(placeHolder: "Your first name", text: $firstName)
                                CustomTextField(placeHolder: "Your last name", text: $firstName)
                                CustomTextField(placeHolder: "Company(Optional)", text: $firstName)
                                CustomTextField(placeHolder: "Address", text: $firstName)
                                CustomTextField(placeHolder: "District", text: $firstName)
                                HStack {
                                    CustomTextField(placeHolder: "Country/Region", isDropDown: true, dropDownItem: ["Hong kong"], text: $firstName)
                                    CustomTextField(placeHolder: "Region", isDropDown: true, dropDownItem: ["Hong kong"], text: $firstName)
                                }
                                CustomTextField(placeHolder: "Your phone number", text: $firstName)
                                HStack {
                                    Rectangle()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.clear)
                                        .overlay {
                                            if isSave {
                                                Image("checkbox_icon")
                                            } else {
                                                Rectangle()
                                                    .stroke(Color(hex: "D2D2D2"), lineWidth: 1)
                                            }
                                        }
                                        .onTapGesture {
                                            isSave.toggle()
                                        }
                                    
                                    Text("Save this information for next time")
                                        .font(.system(size: 14))
                                    Spacer()
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    }
                }
            }
        }
    }
}

struct pickup: View {
    var body: some View {
        Text("pickup")
    }
}

#Preview {
    CheckoutMethodsParentsView()
        .environmentObject(CartEnvironment())
}
