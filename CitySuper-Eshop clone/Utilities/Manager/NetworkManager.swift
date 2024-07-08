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
            let HomePageResponse = try decoder.decode(HomePageResponse.self, from: data)
            
            if let errorMassage = HomePageResponse.error_message {
                throw CSAlert.customError(errorMassage)
            } else {
                return HomePageResponse.data
            }
        } catch {
            throw error
        }
    }
    
    // MARK: LOGIN
    func login(loginData: LoginBody) async throws -> LoginData {
        
        var request = generateURLRequest(host + Constants.login, method: .post)
        
        let postData = try encoder.encode(loginData)
        request.httpBody = postData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        do {
            let loginResponse = try decoder.decode(LoginResponse.self, from: data) 
            
            if let loginData = loginResponse.data {
                return loginData
            } else {
                throw CSAlert.customError(loginResponse.error_message ?? "")
            }
        } catch {
            throw error
        }
    }
    
    // MARK: MultipassToken
    func getAccessToken() async throws -> String {
        
        guard let accessToken = self.userEnv?.shopify_access_token, accessToken.isEmpty else { return self.userEnv?.shopify_access_token ?? ""}
        
        let request = generateURLRequest(host + Constants.multipassToken)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let data = try decoder.decode(MutipassTokenResponse.self, from: data).data {
                return try await withCheckedThrowingContinuation { continuation in
                                Client.shared.getCustomerAccessToken(with: data.multipass_token) { accessToken in
                                    if let accessToken = accessToken {
                                        self.userEnv?.storeShopifyAccessToken(accessToken)
                                        continuation.resume(returning: accessToken)
                                    } else {
                                        continuation.resume(throwing: CSAlert.inValidData)
                                    }
                                }
                            }
            } else {
                throw CSAlert.inValidData
            }
        } catch {
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
            if let data = try decoder.decode(InboxMessageResponse.self, from: data).data {
                return data
            } else {
                throw CSAlert.inValidData
            }
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    func fetchNotificationDetail(_ id: Int) async throws -> MessageDetailData {
        
        let request = generateURLRequest(host + Constants.notificationDetail + "\(id)")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            if let data = try decoder.decode(MessageDetailResponse.self, from: data).data {
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
        
        let request = generateURLRequest(host + Constants.favourites + "\(page)")
        
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
    
    func modifyFavourite(_ shopifyID: String, method: FavModifyType) async throws -> Result<Bool, Error> {
        
        let path = method == .add ? Constants.favourite : Constants.unfavourite
        var request = generateURLRequest(host + path, method: .post)
        
        let params: [String: String] = ["shopify_product_id" : shopifyID.shopifyIDEncode]
        
        let postData = try encoder.encode(params)
        request.httpBody = postData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CSAlert.inValidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return .success(true)
        default:
            return .failure(CSAlert.inValidData)
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
    
        let request = generateURLRequest(host + Constants.collection + collectionID + "/products?page=\(page)&sortKey=\(sortKey.rawValue)&sortOrder=\(sortOrder.rawValue)")

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
    
    func fetchCollectionAllProduct(_ collectionID: String, page: Int) async throws -> CollectionProductsData {
    
        let request = generateURLRequest(host + Constants.collection + collectionID + "/products?page=\(page)")

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
    
    // MARK: StaticPage
    func fetchStaticPage(_ pageName: String) async throws -> StaticPageData {
        
        let request = generateURLRequest(host + Constants.staticPage + pageName)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(StaticPageResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: Coupon
    func fetchCoupon() async throws -> [CouponData] {
        
        let request = generateURLRequest(host + Constants.coupon + "&seitocoupon=1")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(CouponResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }

    // MARK: ShoppingCart Upload
    func uploadShoppingCart(lineItems: [LineItemViewModel]) async throws -> ShoppingCartData {
        
        var params: [ShoppingCartRequest] = []
        
        for _ in lineItems {
            params = lineItems.map{ ShoppingCartRequest(shopify_variant_id:  $0.variant?.id.shopifyIDEncode ?? "", quantity: $0.quantity) }
        }
        
        let postDataDict: Dictionary<String, [ShoppingCartRequest]> = ["cart_items": params]
        let postData = try encoder.encode(postDataDict)
        
        var request = generateURLRequest(host + Constants.shoppingCart, method: .post)
        request.httpBody = postData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(ShoppingCartResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: Navigations
    func fetchNavigations() async throws -> [NavigationsData] {
        
        let request = generateURLRequest(host + Constants.navigations)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(NavigationsResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: Search
    func fetchSuggestion() async throws -> SearchSuggestionData {
        
        let request = generateURLRequest(host + Constants.suggestion)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(SearchSuggestionResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    func fetchKeyword(_ keyword: String) async throws -> SearchKeywordData {
        
        let request = generateURLRequest(host + Constants.summary + "\(keyword)&mode=incremental")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(SearchKeywordResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }

    func fetchKeywordProducts(_ keyword: String, collectionID: String, page: Int, sortKey: String, sortOrder: HttpSortOrderKey) async throws -> SearchResultData {
        
        guard let _keyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { throw CSAlert.inValidURL }
        
        let _collectionID = collectionID.isEmpty ? "" : "&shopify_storefront_id=\(collectionID.shopifyIDEncode)"
        
        let request = generateURLRequest(host + Constants.searchProduct + "\(_keyword)\(_collectionID)&page=\(page)&size=10&sortKey=\(sortKey)&sortOrder=\(sortOrder.rawValue)")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(SearchResultResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    func fetchKeywordResultList(_ keyword: String) async throws -> SearchKeywordData {
        
        let request = generateURLRequest(host + Constants.searchList + "\(keyword)&page=1&page_szie=30")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(SearchKeywordResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    func fetchKeywordResultCollections(_ keyword: String) async throws -> SearchResultCollectionData {

        let request = generateURLRequest(host + Constants.searchCollections + "\(keyword)&page=1&page_szie=30")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(SearchResultCollectionResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: Checkout
    func cloneToCheckout(_ checkoutId: String) async throws -> String {

        let request = generateURLRequest(host + Constants.cloneToCheckout + checkoutId, method: .post)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(CloneToCheckoutResponse.self, from: data).data
        } catch {
            print(error.localizedDescription)
            throw CSAlert.inValidData
        }
    }
    
    // MARK: OTP
    func sendOTP(_ email: String) async throws -> Bool {
        
        var request = generateURLRequest(host + Constants.otp, method: .post)
        
        let postData = try encoder.encode(OTPRequest(app: "CS_ESHOP_APP", email: email))
        request.httpBody = postData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let response = try decoder.decode(OTPResponse.self, from: data)
            
            if let errorMessage = response.error_message {
                throw CSAlert.customError(errorMessage)
            } else {
                return response.success
            }
        } catch {
            throw error
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
