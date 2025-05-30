//
//  DiscountCodeViewModel.swift
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

import MobileBuySDK

final class DiscountCodeViewModel: DiscountApplication, ViewModel {
    
    typealias ModelType = Storefront.DiscountCodeApplication

    let model     : ModelType
    let name      : String
    let applicable: Bool
    var type      : String!
    var price     : Decimal
    
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(from model: ModelType) {
        self.model      = model
        self.name       = model.code
        self.applicable = model.applicable
        
        if let moneyv2 = model.value as? Storefront.MoneyV2{
            self.price = moneyv2.amount
        } else {
            self.price = 0.0
            self.type = "Percentage"
        }
    }
}

extension Storefront.DiscountCodeApplication: ViewModeling {
    typealias ViewModelType = DiscountCodeViewModel
}
