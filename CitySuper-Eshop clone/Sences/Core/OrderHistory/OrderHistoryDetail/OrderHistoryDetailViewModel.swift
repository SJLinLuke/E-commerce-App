//
//  OrderHistoryDetailViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/28.
//

import Foundation

@MainActor final class OrderHistoryDetailViewModel: ObservableObject {
        
    @Published var isLoading: Bool = false
    @Published var orderHistory: OrderViewModel? = nil
    
    let OrderHistoryVM = OrderHistoryViewModel.shared
    
    func fetchOrder(orderID: String) {
        
        guard !isLoading else { return }
        
        isLoading = true
        
        Client.shared.fetchOrder(of: orderID) { order in
            if let order = order {
                self.fetchOrderStatus(order)
            }
        }
    }
    
    func selectedOrderHistory(_ orderHistory: OrderViewModel) {
        self.orderHistory = orderHistory
    }
    
    private func fetchOrderStatus(_ orders: OrderViewModel) {
        DispatchQueue.main.async {
            Task {
                let params: [String: [String]] = ["shopify_order_ids" : [orders.id.shopifyIDEncode]]
                
                do {
                    let ordersInfo = try await NetworkManager.shared.fetchOrderHistoryInfo(params)
                    self.insertOrderInfoAndSetupOrderStatus(orderHistorys: orders,
                                                            orderInfos: ordersInfo)
                } catch {
                    self.isLoading = false
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func insertOrderInfoAndSetupOrderStatus(orderHistorys: OrderViewModel, orderInfos: [OrderData]) {
        DispatchQueue.main.async {
            if orderInfos.indices.contains(0) {
                orderHistorys.orderInfo = orderInfos[0]
            }
            
            orderHistorys.orderStatus = self.OrderHistoryVM.setupOrderStatus(
                fulfillment: orderHistorys.fulfillmentStatus,
                financialStatus: orderHistorys.financialStatus)
            
            orderHistorys.orderMethodInfo = self.OrderHistoryVM.setupOrderMethodInfo(orderHistorys)
            
            self.orderHistory = orderHistorys
            self.isLoading = false
        }
    }
}
