//
//  QRcodeViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/18.
//

import UIKit
import SwiftUI
import CoreImage.CIFilterBuiltins

@MainActor final class QRcodeViewModel: ObservableObject {
        
    @AppStorage("qrcode") private var storage_qrcode: Data?
    
    @Published var isLoading: Bool = false
    @Published var qrcode   : String = ""
    
    func fetchQRcode() {
        
        guard let storedQRCode = self.storage_qrcode else {
            self.loadNewQRCode()
            return
        }
        
        do {
            let qrcodeData = try JSONDecoder().decode(QRcodeData.self, from: storedQRCode)
            if (!qrcodeData.expiry_date.isExpired()) {
                self.qrcode = qrcodeData.qrcode
            } else {
                self.loadNewQRCode()
            }
        } catch {
            self.loadNewQRCode()
        }
    }
    
    private func loadNewQRCode() {
        
        Task {
            do {
                self.isLoading = true
                let qrcodeData = try await NetworkManager.shared.fetchQRcode()
                
                self.qrcode = qrcodeData.qrcode
                self.saveQRcode(qrcodeData)
                
                self.isLoading = false
            } catch {
                print(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    private func saveQRcode(_ QRcodeData: QRcodeData) {
        
        do {
            let data = try JSONEncoder().encode(QRcodeData)
            self.storage_qrcode = data
        } catch {
            print("something went wrong when encode qrcode data")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        
        if let image = UIImage(data: Data(base64Encoded: string)!) {
            return image
        }

        return UIImage()
    }
}
