//
//  OrderViewModel.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import MobileBuySDK

final class OrderViewModel: ViewModel, Identifiable, Equatable {
    
    typealias ModelType = Storefront.OrderEdge
    
    let model:                  ModelType
    let cursor:                 String
    
    let id:                     String
    var orderMethodInfo:        OrderMethodInfo
    let shippingAddress:        AddressViewModel?
    let number:                 Int
    let email:                  String?
    let currentTotalDuties:     Decimal?
    let originalTotalDuties:    Decimal?
    let totalPrice:             Decimal
    let totalShippingPrice:     Decimal
    let fulfillmentStatus:      String
    let financialStatus:        String
    let processedAt:            String
    let lineItems:              [Storefront.OrderLineItem]
    let lineItemsTotalPrice:    Decimal
    
    let discountApplication:    [DiscountApplication]?
    
    var orderInfo:              OrderData
    var orderStatus:            OrderStaus
    
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model               = model
        self.cursor              = model.cursor
        
        self.id                  = model.node.id.rawValue
        self.orderMethodInfo     = OrderMethodInfo(orderMethod: "", orderCompleteDate: "", orderMethodWithDate: "")
        self.shippingAddress     = model.node.shippingAddress?.viewModel
        self.number              = Int(model.node.orderNumber)
        self.email               = model.node.email
        self.currentTotalDuties  = model.node.currentTotalDuties?.amount
        self.originalTotalDuties = model.node.originalTotalDuties?.amount
        self.totalPrice          = model.node.totalPrice.amount
        self.totalShippingPrice  = model.node.totalShippingPrice.amount
        self.fulfillmentStatus   = model.node.fulfillmentStatus.rawValue
        self.financialStatus     = model.node.financialStatus?.rawValue ?? ""
        self.processedAt         = "\(model.node.processedAt)".convertDataFormat(fromFormat: "yyyy-MM-dd HH:mm:ss Z", 
                                                                                 toFormat: "yyyy/MM/dd HH:mm:ss")
        
        self.lineItems           = model.node.lineItems.nodes
        self.lineItemsTotalPrice = self.lineItems.reduce(0){ $0 + $1.originalTotalPrice.amount}
        
        self.orderInfo           = OrderData(shopify_order_id: "", note: nil, custom_attributes: nil, payment_method: nil)
        self.orderStatus         = OrderStaus(status: "", progress: 0, color: .clear)
        
        let discountApplication_edge = model.node.discountApplications.edges
        
        if !discountApplication_edge.isEmpty {
            self.discountApplication = model.node.discountApplications.edges.map { $0.node.resolvedViewModel }
        } else {
            self.discountApplication = []
        }

    }
    
    // ----------------------------------
    //  MARK: - Equatable -
    //
    static func == (lhs: OrderViewModel, rhs: OrderViewModel) -> Bool {
        return lhs.model.node.id.rawValue == rhs.model.node.id.rawValue &&
        lhs.cursor              == rhs.cursor &&
        lhs.id                  == rhs.id &&
        lhs.number              == rhs.number &&
        lhs.email               == rhs.email &&
        lhs.currentTotalDuties  == rhs.currentTotalDuties &&
        lhs.originalTotalDuties == rhs.originalTotalDuties &&
        lhs.totalPrice          == rhs.totalPrice &&
        lhs.fulfillmentStatus   == rhs.fulfillmentStatus &&
        lhs.financialStatus     == rhs.financialStatus &&
        lhs.processedAt         == rhs.processedAt &&
        lhs.orderInfo           == rhs.orderInfo &&
        lhs.orderStatus         == rhs.orderStatus
    }
}

extension Storefront.OrderEdge: ViewModeling {
    typealias ViewModelType = OrderViewModel
}
