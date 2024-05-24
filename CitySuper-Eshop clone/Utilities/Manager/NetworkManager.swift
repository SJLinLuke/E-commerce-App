//
//  NetworkManager.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/11.
//

import UIKit
import SwiftUI
import MobileBuySDK

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
    
    // MARK: CollectionInfo
    func fetchCollectionInfo(_ collectionID: String) async throws -> ProductCollectionData {
        
        let request = generateURLRequest(host + Constants.collection + collectionID)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let data = try decoder.decode(ProductCollectionResponse.self, from: data).data {
                return data
            } else {
                throw CSAlert.inValidData
            }
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: Collection-Products
    func fetchCollectionProduct(_ collectionID: String,
                                page: Int, sortKey: ProductCollectionSortKeys, sortOrder: HttpSortOrderKey) async throws -> CollectionProductsData {
    
        let request = generateURLRequest(host + Constants.collectionProducts + collectionID + "/products?page=\(page)&sortKey=\(sortKey.rawValue)&sortOrder=\(sortOrder.rawValue)")

        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let data = try decoder.decode(CollectionProductsResponse.self, from: data).data {
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
    
    // MARK: Product-Similar
    func fetchSimilarProduct(_ shopifyID: String, page: Int) async throws -> [ProductBody] {
        
        let request = generateURLRequest(host + Constants.productSimilar + shopifyID + "?page=\(page)")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(SimilarRelatedProductResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: Product-Related
    func fetchRelatedProduct(_ shopifyID: String, page: Int) async throws -> [ProductBody] {
        
        let request = generateURLRequest(host + Constants.productRelated + shopifyID + "?page=\(page)")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(SimilarRelatedProductResponse.self, from: data).data
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

enum HttpSortOrderKey: String {
    case ASC = "ASC"
    case DESC = "DESC"
}

enum ProductCollectionSortKeys: String {
    /// Sort by the `best-selling` value.
    case bestSelling = "BEST_SELLING"

    /// Sort by the `collection-default` value.
    case collectionDefault = "COLLECTION_DEFAULT"

    /// Sort by the `created` value.
    case created = "CREATED"

    /// Sort by the `id` value.
    case id = "ID"

    /// Sort by the `manual` value.
    case manual = "MANUAL"

    /// Sort by the `price` value.
    case price = "PRICE"

    /// Sort by relevance to the search terms when the `query` parameter is
    /// specified on the connection. Don't use this sort key when no search query
    /// is specified.
    case relevance = "RELEVANCE"

    /// Sort by the `title` value.
    case title = "TITLE"

    case unknownValue = ""
}
