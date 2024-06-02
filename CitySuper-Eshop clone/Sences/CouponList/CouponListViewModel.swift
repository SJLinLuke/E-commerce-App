//
//  CouponListViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/2.
//

import Foundation

@MainActor final class CouponListViewModel: ObservableObject {
    
    static let shared = CouponListViewModel()
    
    @Published var isLoading: Bool = false
    
}
