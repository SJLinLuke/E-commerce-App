//
//  LineItemViewModel.swift
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

final class LineItemViewModel: ViewModel, Identifiable, Equatable {
    
    typealias ModelType = Storefront.CheckoutLineItemEdge
    
    let model              : ModelType
    let cursor             : String
    
    let id                 : String
    let variantID          : String?
    let title              : String
    var quantity           : Int
    let individualPrice    : Decimal
    let totalPrice         : Decimal
    let variant            : VariantNodeViewModel?
    let discountAllocations: [DiscountAllocationViewModel]
    
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model               = model
        self.cursor              = model.cursor
        
        self.id                  = model.node.id.rawValue
        self.variantID           = model.node.variant!.id.rawValue
        self.title               = model.node.title
        self.quantity            = Int(model.node.quantity)
        self.individualPrice     = model.node.variant!.price.amount
        self.totalPrice          = self.individualPrice * Decimal(self.quantity)
        self.variant             = model.node.variant?.viewModel
        self.discountAllocations = model.node.discountAllocations.viewModels
    }
    
    static func == (lhs: LineItemViewModel, rhs: LineItemViewModel) -> Bool {
        lhs.cursor          == rhs.cursor &&
        lhs.id              == rhs.id &&
        lhs.variantID       == rhs.variantID &&
        lhs.title           == rhs.title &&
        lhs.quantity        == rhs.quantity &&
        lhs.individualPrice == rhs.individualPrice &&
        lhs.totalPrice      == rhs.totalPrice
    }
}

extension Storefront.CheckoutLineItemEdge: ViewModeling {
    typealias ViewModelType = LineItemViewModel
}
