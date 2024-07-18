//
//  CheckoutCompleteView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/14.
//

import SwiftUI

struct CheckoutCompleteView: View {
    
    @EnvironmentObject private var userEnv: UserEnviroment
    @EnvironmentObject private var cartEnv: CartEnvironment
    
    @State var isLoading: Bool = false
        
    let orderNumber: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
                
            Image("order_complete_icon")
                .resizable()
                .frame(width: 230, height: 180)
            
            Text("Your Order is received!")
                .font(.title3)
                .bold()
            
            Text("Order #\(orderNumber.description)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
                .frame(height: 200)
            
            Button {
                completeCheckout()
            } label: {
                ThemeButton(title: "Back to Home")
            }

        }
        .overlay {
            if isLoading {
                LoadingIndicatiorView()
            }
        }
        .modifier(NavigationModifier(isHideCollectionsList: true, isHideShoppingCart: true))
    }
    
    func completeCheckout() {
        DispatchQueue.main.async {
            isLoading = true
            userEnv.updateCheckoutID {
                cartEnv.deleteLocalCheckout(mutate: true) {
                    isLoading = false
                    let homeView = UIHostingController(
                        rootView:
                            MainTabbarView()
                            .environmentObject(userEnv)
                            .environmentObject(cartEnv)
                    )
                    changeRootViewController(to: homeView)
                }
            }
        }
    }
    
    func changeRootViewController(to viewController: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            cartEnv.isShowCheckoutConfirmation = false
            cartEnv.isShowDeliveryOrPickup = false
            cartEnv.fetchCheckout()
        }
    }
}

#Preview {
    CheckoutCompleteView(orderNumber: 2121)
        .environmentObject(CartEnvironment())
        .environmentObject(UserEnviroment())
}
