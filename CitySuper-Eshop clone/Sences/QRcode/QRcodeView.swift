//
//  ProfileQRcodeView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import SwiftUI

struct QRcodeView: View {
    
    @EnvironmentObject var userEnv: UserEnviroment
    
    @StateObject var VM = QRcodeViewModel()
    
    @Binding var isShowingQRcode: Bool
    
    var body: some View {
        ZStack {
            Image(userEnv.isGoldMember ? "QRbg_gold" : "QRbg_green")
            VStack {
                Text("super e\(userEnv.isGoldMember ? "-gold" : "") member")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 10)

                Text("Scan to Pay and Earn Points")
                    .foregroundColor(.white)
                    .fontWeight(.light)
                    .padding(.top, 20)
                
                Spacer()
                    .frame(height: 120)
                
                Qrcode(qrcode: VM.qrcode)
                
                Text(userEnv.accountNumber)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                
                Spacer()
            }
        }
        .task {
            if userEnv.isLogin {
                VM.loadQRcode()
            }
        }
        .overlay(content: {
            if VM.isLoading {
                LoadingIndicatiorView()
            }
        })
        .overlay(alignment: .topTrailing) {
            XDismissButton(isShow: $isShowingQRcode, color: .white)
                .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 25))
        }
        .modifier(AlertModifier(alertItem: VM.alertItem, isAlertShow: $VM.isAlertShow))
    }
}

#Preview {
    QRcodeView(isShowingQRcode: .constant(true))
        .environmentObject(UserEnviroment())
}

struct Qrcode: View {
    
    @StateObject var VM = QRcodeViewModel()
    
    @State var imageName: String = "QR_flash_2020Nov000-1"
    var qrcode          : String = ""
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .frame(width: 300, height: 300)
                .onAppear {
                    setUpAnimation()
                }
            
            Image(uiImage: VM.generateQRCode(from: qrcode))
                .resizable()
                .interpolation(.none)
                .frame(width: 250, height: 250)
                
        }
    }
   
    func setUpAnimation() {
        var index = 1
        _ = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { (Timer) in
            
            DispatchQueue.main.async {
                imageName = "QR_flash_2020Nov000-\(index)"
            }
            
            index += 1
            
            if (index > 28){
                index = 1
            }
        }
    }
}
