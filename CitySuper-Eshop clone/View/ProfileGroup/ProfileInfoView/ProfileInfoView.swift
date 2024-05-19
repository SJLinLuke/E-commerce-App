//
//  ProfileInfoView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/15.
//

import SwiftUI

struct ProfileInfoView: View {
    
    @EnvironmentObject var userEnv: UserEnviroment
    
    @State var isShowingQrcode: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image(userEnv.isGoldMember ? "gold_card" : "green_card")
                    .padding(EdgeInsets(top: 15, leading: 5, bottom: 3, trailing: 0))
                
                VStack(alignment: .leading) {
                    Text(userEnv.memberName)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .padding(.bottom, 5)
                        
                    Text("Loyalty Point: \(userEnv.loyaltyPoints) pts")
                        .font(.caption2)
                        .padding(.bottom, -5)
                    Rectangle()
                        .frame(height: 1)
                    Text("as of \(userEnv.asOfDate)")
                        .font(.caption2)
                        .padding(.top, -5)
                }
                .padding(.top, -15)
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 5){
                        Text("Member ID: \(userEnv.accountNumber)")
                        Text("Anniversary date: \(userEnv.anniversaryDate)")
                    }
                    .font(.caption)
                    .padding(.vertical, 5)
                    
                    Spacer()
                    Button {
                        DispatchQueue.main.async {
                            isShowingQrcode.toggle()
                        }
                    } label: {
                        Image("qrcode_icon")
                            .padding(.bottom, 10)
                    }
                }
                
                Progress(height: 7, figureTarget: 300, color: userEnv.isGoldMember ? .vipGold : .themeGreen)
                    .padding(.top, -8)
                    
                Text("Spend HK$ 30,000.00 more in current anniversary year to renew to super e-gold membership")
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
            }
            .padding(EdgeInsets(top: 2, leading: 15, bottom: 0, trailing: 15))
            .background(.white)
        }
        .background(Color(hex: "F2F2F7"))
        .fullScreenCover(isPresented: $isShowingQrcode) {
            QRcodeView(isShowingQRcode: $isShowingQrcode)
        }
    }
}

#Preview {
    ProfileInfoView()
        .environmentObject(UserEnviroment())
}
