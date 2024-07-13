//
//  AVPlayerView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/23.
//

import SwiftUI
import AVKit

struct AVPlayerView: View {
    
    @AppStorage("isShowedTurorial") private var isShowedTurorial: Bool?
    
    @Binding var isShowIntoVideo: Bool
    @Binding var isShowTutorial : Bool
    
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.isShowIntoVideo = false
                NotificationCenter.default.removeObserver(self, name: AVPlayerItem.didPlayToEndTimeNotification, object: player.currentItem)
                if isShowedTurorial == nil {
                    self.isShowTutorial = true
                }
            }
        }
    }
}


#Preview {
    AVPlayerView(isShowIntoVideo: .constant(true), isShowTutorial: .constant(false))
}
