//
//  OrderNodeModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/28.
//

import Foundation
import MobileBuySDK

final class OrderNodeModel: ViewModel {
    
    typealias ModelType = Storefront.Order
    
    let model:               ModelType
    var cursor:              String
    
    let id:                  String
    var orderMethodInfo:     OrderMethodInfo
    let shippingAddress:     AddressViewModel?
    let number:              Int
    let email:               String?
    let currentTotalDuties:  Decimal?
    let originalTotalDuties: Decimal?
    let totalPrice:          Decimal
    let totalShippingPrice : Decimal
    let fulfillmentStatus :  String
    let financialStatus :    String
    let processedAt:         String
    let lineItems:           [Storefront.OrderLineItem]
    let lineItemsTotalPrice: Decimal
    
    var discountApplication: [DiscountApplication]?
    
    var orderInfo:           OrderData
    var orderStatus:         OrderStaus
    
    required init(from model: ModelType) {
        self.model               = model
        self.cursor              = ""
        
        self.id                  = model.id.rawValue
        self.orderMethodInfo     = OrderMethodInfo(orderMethod: "", orderCompleteDate: "", orderMethodWithDate: "")
        self.shippingAddress     = model.shippingAddress?.viewModel
        self.number              = Int(model.orderNumber)
        self.email               = model.email
        self.currentTotalDuties  = model.currentTotalDuties?.amount
        self.originalTotalDuties = model.originalTotalDuties?.amount
        self.totalPrice          = model.totalPrice.amount
        self.totalShippingPrice  = model.totalShippingPrice.amount
        self.fulfillmentStatus   = model.fulfillmentStatus.rawValue
        self.financialStatus     = model.financialStatus?.rawValue ?? ""
        self.processedAt         = "\(model.processedAt)".convertDataFormat(fromFormat: "yyyy-MM-dd HH:mm:ss Z",
                                                                                 toFormat: "yyyy/MM/dd HH:mm:ss")
        
        self.lineItems           = model.lineItems.nodes
        self.lineItemsTotalPrice = self.lineItems.reduce(0){ $0 + $1.originalTotalPrice.amount}
        
        self.orderInfo           = OrderData(shopify_order_id: "", note: nil, custom_attributes: nil, payment_method: nil)
        self.orderStatus         = OrderStaus(status: "", progress: 0, color: .clear)
        
        let discountApplication_edge = model.discountApplications.edges
        
        if !discountApplication_edge.isEmpty {
            self.discountApplication = model.discountApplications.edges.map { $0.node.resolvedViewModel }
        } else {
            self.discountApplication = []
        }
    }
    
    func convertToViewModel() -> OrderViewModel? {
        do {
            var fields: [String: Any] = [:]
            
            fields["cursor"] = self.cursor
            fields["node"] = self.model.rawValue
            
            let edge = try Storefront.OrderEdge(fields: fields)
            
            return OrderViewModel(from: edge)
        } catch {
            print("Something went wrong when converting \(self.model): \(error)")
        }
        return nil
    }
     
}

extension Storefront.Order: ViewModeling {
    typealias ViewModelType = OrderNodeModel
}
