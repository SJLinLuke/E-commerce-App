//
//  InboxDetailViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/27.
//

import Foundation

@MainActor final class InboxDetailViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var inboxMessageDetail: MessageDetailData?
    
    var title: String {
        inboxMessageDetail?.title ?? ""
    }
    
    var publish_time: String {
        inboxMessageDetail?.publish_time.convertDataFormat(fromFormat: "yyyy/MM/dd hh:mm:ss", toFormat: "yyyy/MM/dd") ?? ""
    }
    
    var htmlContent: String {
        self.HTMLImageCorrector(HTMLString: inboxMessageDetail?.content ?? "")
    }
    
    var buttonTitle: String {
        if let button_text = inboxMessageDetail?.button_text {
            return button_text
        } else {
            return inboxMessageDetail?.expired ?? false ? "Ended" : "View Detail"
        }
    }
    
    var imageSrc: String {
        if !(inboxMessageDetail?.images_src?.isEmpty ?? true) {
            return inboxMessageDetail?.images_src?[0] ?? ""
        }
        return ""
    }
    
    var isShowButton: Bool {
        if (inboxMessageDetail?.link_type == nil && inboxMessageDetail?.button_text == nil) || (inboxMessageDetail?.link_type == "DiscountCode" || (inboxMessageDetail?.link_type == "VACoupon")) {
            return false
        } else {
            return true
        }
    }
    
    func fetchInboxMessageDetail(id: Int) {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                self.inboxMessageDetail = try await NetworkManager.shared.fetchNotificationDetail(id)
                self.isLoading = false
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    private func HTMLImageCorrector(HTMLString: String) -> String {
        var HTMLToBeReturned = HTMLString
        while HTMLToBeReturned.range(of: "(?<=width=\")[^\" height]+", options: .regularExpression) != nil{
            if let match = HTMLToBeReturned.range(of:"(?<=width=\")[^\" height]+", options: .regularExpression) {
                HTMLToBeReturned.removeSubrange(match)
                if let match2 = HTMLToBeReturned.range(of:"(?<=height=\")[^\"]+", options: .regularExpression) {
                    HTMLToBeReturned.removeSubrange(match2)
                    let string2del = "width=\"\" height=\"\""
                    HTMLToBeReturned = HTMLToBeReturned.replacingOccurrences(of:string2del, with: "")
                }
            }
        }
        return HTMLToBeReturned
    }
}
