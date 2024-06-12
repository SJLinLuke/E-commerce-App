//
//  VariantNodeViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/11.
//

import Foundation
import MobileBuySDK

final class VariantNodeViewModel: ViewModel{
    typealias ModelType = Storefront.ProductVariant
    
    let model            : ModelType
    let id               : String
    
    let title            : String
    let price            : Decimal
    let comparePrice     : Decimal
    let quantityAvailable: Int
    let image            : URL?
    
    required init(from model: ModelType) {
        self.model = model
        self.id    = model.id.rawValue
        
        self.title             = model.title
        self.price             = model.price.amount
        self.comparePrice      = model.compareAtPrice?.amount ?? 0.0
        self.quantityAvailable = Int(model.quantityAvailable ?? 0)
        self.image             = model.image?.url
    }
}

extension Storefront.ProductVariant: ViewModeling {
    typealias ViewModelType = VariantNodeViewModel
}
