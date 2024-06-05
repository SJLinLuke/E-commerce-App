//
//  OrderHistoryViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/19.
//

import Foundation

@MainActor final class OrderHistoryViewModel: ObservableObject {
    
    static let shared = OrderHistoryViewModel()
    
    @Published var userEnv               : UserEnviroment?
    @Published var isLoading             : Bool = false
    @Published private var orderHistories: [OrderViewModel] = []
    
    private var isHasNextPage: Bool = true
    private var nextCursor   : String? = nil
    
    func fetchOrderHistories() {
        
        guard !isLoading && isHasNextPage else { return }
        
        Task {
            self.isLoading = true
            let accessToken = try await NetworkManager.shared.getAccessToken()
            
            Client.shared.fetchCustomerAndOrders(after: self.nextCursor ?? nil, accessToken: accessToken) { orders in
                if let orders = orders?.orders {
                    self.fetchOrderStatus(orders.items)
                    
                    self.isHasNextPage = orders.hasNextPage
                    self.nextCursor    = orders.items.last?.cursor
                } else {
                    self.isLoading  = false
                }
            }
        }
    }
    
    private func fetchOrderStatus(_ orders: [OrderViewModel]) {
        DispatchQueue.main.async {
            Task {
                let params: [String: [String]] = ["shopify_order_ids" : orders.map{ $0.id.shopifyIDEncode }]
                
                do {
                    let ordersInfo = try await NetworkManager.shared.fetchOrderHistoryInfo(params)
                    self.insertOrderInfoAndSetupOrderStatus(orderHistorys: orders,orderInfos: ordersInfo)
                } catch {
                    self.isLoading = false
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func insertOrderInfoAndSetupOrderStatus(orderHistorys: [OrderViewModel], orderInfos: [OrderData]) {
        DispatchQueue.main.async {
            for index in orderHistorys.indices {
                if orderInfos.indices.contains(index) {
                    orderHistorys[index].orderInfo = orderInfos[index]
                }
                orderHistorys[index].orderStatus = self.setupOrderStatus(fulfillment: orderHistorys[index].fulfillmentStatus,
                                                                         financialStatus: orderHistorys[index].financialStatus)
                orderHistorys[index].orderMethodInfo = self.setupOrderMethodInfo(orderHistorys[index])
            }
            self.orderHistories.append(contentsOf: orderHistorys)
            self.isLoading = false
        }
    }
    
    func setupOrderMethodInfo(_ orderHistory: OrderViewModel) -> OrderMethodInfo {
        let isAppOrder = orderHistory.orderInfo.shopify_order_id.shopifyIDDecode == orderHistory.id.shopifyIDEncode.shopifyIDDecode
        if isAppOrder {
            if let custom_attributes = orderHistory.orderInfo.custom_attributes{
                
                for custom_attribute in custom_attributes{
                    
                    if let name = custom_attribute["name"], let date = custom_attribute["value"] {
                        
                        let date = date.convertDataFormat(fromFormat: "yyyy-MM-dd", toFormat: "yyyy/MM/dd")
                        
                        if name == "Delivery Date"{
                            return OrderMethodInfo(orderMethod: "Delivery", orderCompleteDate: date, orderMethodWithDate: "Estimate delivery on \(date)")
                        }
                        
                        if name == "Pickup Date"{
                            return OrderMethodInfo(orderMethod: "Pickup", orderCompleteDate: date, orderMethodWithDate: "Estimate pickup on \(date)")
                        }
                    }
                }
            }
        }
        return OrderMethodInfo(orderMethod: "", orderCompleteDate: "", orderMethodWithDate: "")
    }
    
    func setupOrderStatus(fulfillment: String, financialStatus: String) -> OrderStaus{
        
        if financialStatus == "PENDING"{
            return OrderStaus(status: "Payment Pending", progress: 0.2, color: .themeDarkGreen)
        }
        
        if fulfillment == "UNFULFILLED" {
            if financialStatus == "PAID"{
                return OrderStaus(status: "Processing", progress: 0.65, color: .themeDarkGreen)
            }
            
            if financialStatus == "PARTIALLY_REFUNDED" || financialStatus == "REFUNDED" {
                return OrderStaus(status: "Refunded" , progress: 0.65, color: .gray)
            }
        }
        
        if fulfillment == "FULFILLED"{
            if financialStatus == "PAID"{
                return OrderStaus(status: "Completed", progress: 1.0, color: .gray)
            }
            
            if financialStatus == "PARTIALLY_REFUNDED" || financialStatus == "REFUNDED" {
                return OrderStaus(status: "Refunded", progress: 1.0, color: .gray)
            }
        }
        
        
        return OrderStaus(status: "Processing", progress: 0.65, color: .themeDarkGreen)
    }
    
    func getHistorys(_ orderNumber: String, sort: String) -> [OrderViewModel] {
        if orderNumber.isEmpty {
            if sort == "ALL" {
                return self.orderHistories
            } else {
                return self.orderHistories.filter({ orderHistory in
                    let match = orderHistory.orderStatus.status == sort
                    return match ? true : false
                })
            }
        } else {
            if sort == "ALL" {
                return self.orderHistories.filter({ orderHistory in
                    let match = "\(orderHistory.number)".range(of: orderNumber) != nil
                    return match ? true : false
                })
            } else {
                return self.orderHistories.filter({ orderHistory in
                    let match = ("\(orderHistory.number)".range(of: orderNumber) != nil) && orderHistory.orderStatus.status == sort
                    return match ? true : false
                })
            }
            
        }
    }
    
    func initHistorys() {
        self.orderHistories = []
        self.isHasNextPage = true
        self.nextCursor    = nil
        self.isLoading     = false
    }
}
