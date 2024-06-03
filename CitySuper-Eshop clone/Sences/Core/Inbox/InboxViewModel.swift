//
//  InboxViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/16.
//

import Foundation

@MainActor final class InboxViewModel: ObservableObject {
    
    static let shared = InboxViewModel()
    
    @Published var isLoading    : Bool = false
    @Published var isHasMore    : Bool = true
    @Published var inBoxMessages: [InboxMessage] = []
    @Published var unreadNumber : Int = 0

    private var currentPage: Int = 1
    
    func fetchInbox() {
        
        guard !isLoading else { return }
        
        Task {
            do {
                self.isLoading = true
                let inboxMessages = try await NetworkManager.shared.fetchNotification(self.currentPage)
                
                if (self.currentPage != inboxMessages.last_page) {
                    self.currentPage += 1
                } else {
                    self.isHasMore = false
                }
                
                self.inBoxMessages.append(contentsOf: inboxMessages.data)
                
                self.isLoading = false
                
            } catch {
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchUnreadNumber() {
        Task {
            do {
                self.unreadNumber = try await NetworkManager.shared.fetchUnreadNumber()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func readInboxMessage(_ id: Int) {
        guard !self.inBoxMessages.isEmpty else { return }
        
        for (index, inBoxMessage) in inBoxMessages.enumerated() {
            if inBoxMessage.id == id {
                self.inBoxMessages[index].read = true
                self.unreadNumber -= 1
            }
        }
    }
    
    func initInboxMessages() {
        self.inBoxMessages = []
        self.currentPage   = 1
        self.isHasMore     = true
        self.isLoading     = false
        self.unreadNumber  = 0
    }
}

