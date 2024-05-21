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
    
    // MARK: MultipassToken
    func getMultipassToken() async throws -> String {
        
        let request = generateURLRequest(host + Constants.multipassToken)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let data = try decoder.decode(MutipassTokenResponse.self, from: data).data {
                return data.multipass_token
            } else {
                throw CSAlert.inValidData
            }
        } catch {
            print(error)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: OrderHistoryInfo
    func fetchOrderHistoryInfo(_ params: [String: [String]]) async throws -> [OrderData] {
                
        var urlComponents = URLComponents(url: URL(string: host + Constants.orderInfos)!, resolvingAgainstBaseURL: false)!
        
        var queryItems: [URLQueryItem] = []
        for (key, values) in params {
            for value in values {
                queryItems.append(URLQueryItem(name: "\(key)[]", value: value))
            }
            
        }
        urlComponents.queryItems = queryItems
        
        let request = generateURLRequest(urlComponents: urlComponents)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let data = try decoder.decode(OrderResponse.self, from: data).data {
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
    
    // MARK: Product
    func fetchProduct(_ shopifyID: String) async throws -> ProductBody {
        
        let request = generateURLRequest(host + Constants.product + shopifyID)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(ProductResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
}

extension NetworkManager {
    func generateURLRequest(_ url: String? = nil, method: HttpRequestMethodType? = nil, urlComponents: URLComponents? = nil) -> URLRequest {
        
        if let url = URL(string: (url ?? urlComponents?.url?.description) ?? "") {
            
            var request = URLRequest(url: urlComponents?.url ?? url)
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
