//
//  NetworkManager.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import UIKit
import SwiftUI

final class NetworkManager: ObservableObject {
    
    static let shared = NetworkManager()

    var userEnv: UserEnviroment? = nil
    
    let host = Constants.host
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    // MARK: HOME
    func fetchHomePage() async throws -> [HomePageModule] {
        
        let request = generateURLRequest(host + Constants.homepage)
        
        let (data, _) = try await URLSession.shared.data(for: request)
    
        do {
            return try decoder.decode(HomePageResponse.self, from: data).data
        } catch {
            print(error)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: LOGIN
    func login(loginData: LoginBody) async throws -> LoginData {
        
        var request = generateURLRequest(host + Constants.login, method: .post)
        
        let postData = try encoder.encode(loginData)
            request.httpBody = postData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let data = try decoder.decode(LoginResponse.self, from: data).data {
                return data
            } else {
                throw CSAlert.inValidData
            }
        } catch {
            print(error)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: Notification
    func fetchNotification(_ page: Int) async throws -> InboxMessageData {
        
        let request = generateURLRequest(host + Constants.notification + "\(page)")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let data = try decoder.decode(MessageResponse.self, from: data).data {
                return data
            } else {
                throw CSAlert.inValidData
            }
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: Unread
    func fetchUnreadNumber() async throws -> Int {
        
        let request = generateURLRequest(host + Constants.unread)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(UnreadResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: Favourite
    func fetchFavourites(_ page: Int) async throws -> FavouriteData {
        
        let request = generateURLRequest(host + Constants.favourite + "\(page)")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let data = try decoder.decode(FavouriteResponse.self, from: data).data {
                return data
            } else {
                throw CSAlert.inValidData
            }
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: QRcode
    func fetchQRcode() async throws -> QRcodeData {
        
        let request = generateURLRequest(host + Constants.qrcode)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let data = try decoder.decode(QRcodeResponse.self, from: data).data {
                return data
            } else {
                throw CSAlert.inValidData
            }
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
}

extension NetworkManager {
    func generateURLRequest(_ url: String, method: HttpRequestMethodType? = nil) -> URLRequest {
        
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
                request.setValue("en", forHTTPHeaderField: "locale")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("iOS", forHTTPHeaderField: "Platform")
            
            if let method = method {
                switch method {
                    case .post:
                        request.httpMethod = method.rawValue
                    }
            }
            
            if let userEnv = userEnv, userEnv.isLogin {
                request.setValue("Bearer \(userEnv.token)", forHTTPHeaderField: "Authorization")
            }
            
            return request
        }
        return URLRequest(url: URL(string: "")!)
    }
}

enum HttpRequestMethodType: String {
    case post = "POST"
}
