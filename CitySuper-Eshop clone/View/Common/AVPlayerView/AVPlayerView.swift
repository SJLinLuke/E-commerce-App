//
//  AVPlayerView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/23.
//

import SwiftUI
import AVKit

struct AVPlayerView: View {
    
    @Binding var isShowingIntoVideo: Bool
    
    private var player: AVPlayer {
        let player = AVPlayer(url: Bundle.main.url(forResource: "CS_SplashVideo", withExtension: "mp4")!)
        addObserver(for: player)
        player.play()
        return player
    }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .onAppear {
                    player.play()
                }
                .background(.white)
                .aspectRatio(contentMode: .fill)
                .disabled(true)
        }
    }
    
    private func addObserver(for player: AVPlayer) {
        NotificationCenter.default.addObserver(forName: AVPlayerItem.didPlayToEndTimeNotification, object: player.currentItem, queue: .main) { _ in
            DispatchQueue.main.async {
                self.isShowingIntoVideo = false
                NotificationCenter.default.removeObserver(self, name: AVPlayerItem.didPlayToEndTimeNotification, object: player.currentItem)
            }
        }
    }
}


#Preview {
    AVPlayerView(isShowingIntoVideo: .constant(true))
}
