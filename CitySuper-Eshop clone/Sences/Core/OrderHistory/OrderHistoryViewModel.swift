//
//  OrderHistoryViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/19.
//

import Foundation

@MainActor final class OrderHistoryViewModel: ObservableObject {
    
    static let shared = OrderHistoryViewModel()
    
    @Published var userEnv      : UserEnviroment?
    @Published var isLoading    : Bool = false
    @Published var orderHistorys: [OrderViewModel] = []
    
    private var isHasNextPage: Bool = true
    private var nextCursor   : String? = nil
    
    func fetchOrder() {
        
        guard !isLoading && isHasNextPage else { return }
        
        DispatchQueue.main.async {
            Task {
                self.isLoading = true
                let mutipassToken = try await NetworkManager.shared.getMultipassToken()
                
                Client.shared.getCustomerAccessToken(with: mutipassToken) { access_token in
                    if let access_token = access_token{
                        Client.shared.fetchCustomerAndOrders(after: self.nextCursor ?? nil, accessToken: access_token) { orders in
                            if let orders = orders?.orders {
                                self.fetchOrderStatus(orders.items)
                                
                                self.isHasNextPage = orders.hasNextPage
                                self.nextCursor    = orders.items.last?.cursor
                            } else {
                                self.isLoading  = false
                            }
                        }
                    } else {
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    private func fetchOrderStatus(_ orders: [OrderViewModel]) {
        DispatchQueue.main.async {
            Task {
                let params: [String: [String]] = ["shopify_order_ids" : orders.map{ $0.id.shopifyIdEncode }]
                
                do {
                    let ordersInfo = try await NetworkManager.shared.fetchOrderHistoryInfo(params)
                    self.insertOrderInfo(orderHistorys: orders,orderInfos: ordersInfo)
                } catch {
                    self.isLoading = false
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func insertOrderInfo(orderHistorys: [OrderViewModel], orderInfos: [OrderData]) {
        DispatchQueue.main.async {
            for index in orderHistorys.indices {
                if orderInfos.indices.contains(index) {
                    orderHistorys[index].orderInfo = orderInfos[index]
                }
            }
            self.orderHistorys.append(contentsOf: orderHistorys)
            self.isLoading = false
        }
    }
    
}
