//
//  PickupView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/30.
//

import SwiftUI

struct PickupView: View {
    
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    @State var currentSelectedCity: String = "ALL"
    @State var dropDownItems_city: [String] = ["ALL"]
    
    let screenWidth = UIScreen.main.bounds.width * 0.95
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Text("Pickup Store")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 5, trailing: 0))
                
                CustomTextField(placeHolder: "", isDropDown: true, dropDownItem: dropDownItems_city, height: 50, isShowDropDown: true, text: $currentSelectedCity)
                    .frame(width: screenWidth)
                
                ScrollView {
                    ForEach(cartEnv.getPickupLocations(currentSelectedCity), id: \.self) { store in
                        
                        SeperateLineView(color: Color(hex: "DADADA"),height: 0.5, width: screenWidth * 0.9)
                        
                        PickupStoreTagsView(store: store)
                            .onTapGesture {
                                cartEnv.currentSelectedStore = store
                            }
                    }
                }
                .frame(maxHeight: 400)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hex: "DADADA"),lineWidth: 2)
                }
                .padding(EdgeInsets(top: 10, leading: 9, bottom: 10, trailing: 9))
                
                HStack {
                    Text("Pickup time :")
                        .bold()
                    Text(cartEnv.currentSelectedDate.convertDataFormat(fromFormat: "yyyy-MM-dd", toFormat: "yyyy/MM/dd") + " \(cartEnv.currentSelectedStore?.open_at ?? "")-\(cartEnv.currentSelectedStore?.close_at ?? "")")
                    Spacer()
                }
                .font(.system(size: 14))
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
                
                CalendarView(currentSelectedDate: $cartEnv.currentSelectedDate, startDate: cartEnv.pickupStartDate, endDate: cartEnv.pickupEndDate)
                
                Button {
                    
                } label: {
                    ThemeButton(title: "Confirm", width: screenWidth)
                        .padding(.top)
                }
            }
            .onAppear {
                self.dropDownItems_city.append(contentsOf: Array(cartEnv.getPickupLocations("ALL").map() {$0.city ?? ""}))
            }
        }
    }
}

#Preview {
    PickupView()
        .environmentObject(CartEnvironment())
}
