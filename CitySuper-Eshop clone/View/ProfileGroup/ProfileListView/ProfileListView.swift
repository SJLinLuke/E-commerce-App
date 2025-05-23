//
//  ProfileListView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/15.
//

import SwiftUI
import Stripe

struct ProfileListView: View {
    
    @ObservedObject var paymentContextDelegate: PaymentContextDelegate = PaymentContextDelegate.shared
    
    @EnvironmentObject var userEnv: UserEnviroment
    @EnvironmentObject var cartEnv: CartEnvironment
    
    @StateObject var VM = ProfileViewModel()
    
    @State var isShowingLoginView     : Bool = false
    @State var isShowingOrderHistory   : Bool = false
    @State var isShowingDeliveryAddress: Bool = false
    @State var isShowingMoreList       : Bool = false
    @State var isShowingCouponList     : Bool = false
    
    @State private var paymentContext: STPPaymentContext!
    
    var body: some View {
        List(VM.getProfileData(), rowContent: { rowData in
            CustomListCell(rowData: rowData)
                .onTapGesture {
                    tapCell(rowData)
                }
        })
        .onAppear{
            VM.userEnv = userEnv
            self.paymentContextConfiguration()
        }
        .listStyle(.plain)
        .listSectionSeparator(.hidden, edges: .all)
        .environment(\.defaultMinListRowHeight, 55)
        .padding(.top, -3)
        .fullScreenCover(isPresented: $isShowingLoginView) {
            LoginView(isShow: $isShowingLoginView)
        }
        .navigationDestination(isPresented: $isShowingOrderHistory) {
            OrderHistoryView(selectIndex: .constant(1))
        }
        .navigationDestination(isPresented: $isShowingDeliveryAddress) {
            DeliveryAddressView()
        }
        .navigationDestination(isPresented: $isShowingMoreList) {
            MoreListView()
        }
        .navigationDestination(isPresented: $isShowingCouponList) {
            CouponListView(isRedeemable: false)
        }
    }
    
    func tapCell(_ rowData: CustomListRowModel) {
        DispatchQueue.main.async {
            switch rowData.title {
            case "E-Shop Coupon":
                isShowingCouponList.toggle()
            case "Order History":
                isShowingOrderHistory.toggle()
            case "Delivery Address":
                isShowingDeliveryAddress.toggle()
            case "Wallet":
                self.paymentContext.presentPaymentOptionsViewController()
            case "More":
                isShowingMoreList.toggle()
            case "Login":
                isShowingLoginView.toggle()
            case "Logout":
                userEnv.removeUser()
                cartEnv.deleteLocalCheckout()
                OrderHistoryViewModel.shared.initHistorys()
                InboxViewModel.shared.initInboxMessages()
                FavouriteViewModel.shared.initFavourites()
            default:
                break
            }
            
        }
    }
    
    func paymentContextConfiguration() {
        let customerContext = STPCustomerContext(keyProvider: StripeManager())
        self.paymentContext = STPPaymentContext(
                                customerContext: customerContext,
                                configuration: StripeManager.shared.config,
                                theme: StripeManager.shared.theme
                              )
        self.paymentContext.delegate = self.paymentContextDelegate

        let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
        
        self.paymentContext.hostViewController = keyWindow?.rootViewController
    }
}

#Preview {
    ProfileListView()
        .environmentObject(UserEnviroment())
}
