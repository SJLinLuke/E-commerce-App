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
    
    @Published var couponsCount: Int = 0
    @Published var coupons: [CouponData] = [] {
        didSet {
            couponsCount = coupons.count
        }
    }
    
    init() {
        fetchCoupon()
    }
    
    func fetchCoupon() {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                self.coupons = try await NetworkManager.shared.fetchCoupon()
                self.isLoading = false
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
}
