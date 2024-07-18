//
//  CheckoutConfirmationView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/30.
//

import SwiftUI
import Stripe

struct CheckoutConfirmationView: View {

    @EnvironmentObject var userEnv: UserEnviroment
    @EnvironmentObject var cartEnv: CartEnvironment

    @ObservedObject var paymentContextDelegate: PaymentContextDelegate = PaymentContextDelegate.shared
    
    @StateObject private var VM: CheckoutConfirmationViewModel
    @StateObject private var alertManager = AlertManager()
    
    @State private var paymentContext: STPPaymentContext!

    @State var isShowCoupon: Bool = false
    @State var isShowOption: Bool = false

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
                                    .frame(width: 20, height: 20)
                            }
                        )
                        
                        Spacer()
                        
                        Button {
                            isShowCoupon.toggle()
                        } label: { Text("Edit") }
                    }
                    .font(.system(size: 16))
                    .foregroundColor(.themeDarkGreen)
                    .padding(.vertical, 5)
                    
                    SeperateLineView()
                    
                    CustomFormTextItem(
                        leadingText: "Items Subtotal",
                        trailingText: Currency.stringFrom(VM.subTotal))
                    
                    ForEach(VM.discountApplication.indices, id: \.self) { index in
                        if let discount = VM.discountApplication[index] as? DiscountCodeViewModel {
                            CustomFormTextItem(
                                leadingText: discount.name,
                                trailingText: "-" + Currency.stringFrom(
                                    // The price of type "Percentage" will not be return in discountApplication
                                    discount.type == "Percentage" ? VM.calculateDiscountPrice(discount.name) : discount.price),
                                leadingColor: .themeDarkGreen,
                                trailingColor: .themeDarkGreen
                            )
                        }
                        
                        if let discount = VM.discountApplication[index] as? ScriptCodeViewModel {
                            CustomFormTextItem(
                                leadingText: discount.name,
                                trailingText: "-" + Currency.stringFrom(discount.price),
                                leadingColor: .themeDarkGreen,
                                trailingColor: .themeDarkGreen
                            )
                        }
                    }
                    
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
                                       trailingText: VM.checkedDate?.convertDataFormat(fromFormat: "yyyy-MM-dd",
                                                                                       toFormat: "yyyy/MM/dd") ?? "")
                    
                    CustomFormTextItem(leadingText: VM.isDelivery ? "Delivery Address" : "Pickup Store",
                                       trailingText: VM.shippingAddress,
                                       alignment: .top)
                }
                .padding(.horizontal, 10)
                
                OrderHistoryDetailSectionHeader(title: "Note")
                
                VStack {
                    HStack {
                        TextField("Remark", text: $VM.checkoutRemark)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 100 ,maxHeight:  100, alignment: .top)
                    .padding(.horizontal, 5)
                    
                    Spacer()
                }
                
                OrderHistoryDetailSectionHeader(title: "Payment", buttonTitle: "Change", action: {})

                let attributedString = AttributedString(paymentContextDelegate.paymentMethod)

                HStack {
                    Text(attributedString)
                    Spacer()
                }
                .padding(.horizontal, 5)
                
                SeperateLineView()
                
                Button {
                    VM.tapOnPay(paymentContext: self.paymentContext)
                } label: {
                    ThemeButton(title: "Pay", font: .title3)
                }
                .padding(.top)
                
            }
            .onAppear {
                VM.initCheckout()
                VM.alertManager = self.alertManager
                VM.userEnv      = self.userEnv
                
                self.paymentContextConfiguration()
            }
        }
        .overlay {
            if VM.isLoading || self.paymentContextDelegate.isLoading {
                LoadingIndicatiorView(backgroundDisable: true)
            }
        }
        .modifier(NavigationModifier(navTilte: "Order Detail", isHideCollectionsList: true, isHideShoppingCart: true))
        .modifier(AlertModifier(alertItem: alertManager.alertItem, isAlertShow: $alertManager.isShowAlert))
        .navigationDestination(isPresented: $isShowCoupon) {
            CouponListView(confirmationVM: VM,isRedeemable: true)
        }
        .navigationDestination(isPresented: $paymentContextDelegate.isShowComolete) {
            CheckoutCompleteView(orderNumber: VM.orderNumber)
        }
    }
 
    func paymentContextConfiguration() {
        
        self.paymentContextDelegate.cartEnv      = cartEnv
        self.paymentContextDelegate.alertManager = self.alertManager
        
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

//#Preview {
//    CheckoutConfirmationView()
//}
