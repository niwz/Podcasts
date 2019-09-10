//
//  PlayerDetailView.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/8/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import AVKit
import Stevia

class PlayerDetailView: UIView {

    var episode: Episode! {
        didSet {
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            imageView.sd_setImage(with: url)
            miniPlayerView.episodeImageView.sd_setImage(with: url)
            titleLabel.text = episode.title
            miniPlayerView.titleLabel.text = episode.title
            artistLabel.text = episode.author
            playPodcast()
        }
    }

    var panGesture: UIPanGestureRecognizer!

    let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()

    func playPodcast() {
        guard let url = URL(string: episode.streamUrl) else { return }
        controlsView.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayerView.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let progressSliderView = ProgressSliderView()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "EPISODE TITLE"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.height(>=20)
        return label
    }()

    let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist Name"
        label.textColor = .purple
        label.textAlignment = .center
        label.height(20)
        return label
    }()

    var controlsView = PlayerControlsView()

    let volumeSliderView = VolumeSliderView()

    lazy var labelStack = VStack(arrangedSubviews: [titleLabel, artistLabel], spacing: 4)
    lazy var maximizedStackView = VStack(arrangedSubviews: [imageView, progressSliderView, labelStack, controlsView, volumeSliderView, UIView()])

    let miniPlayerView = MiniPlayerView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupGestures()
        setupUI()
        setupSlider()
        setupControls()
    }


    //MARK:- Setup Gestures
    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize))
        addGestureRecognizer(tapGestureRecognizer)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }

    //MARK:- Setup UI
    private func setupUI() {
        maximizedStackView.distribution = .equalSpacing
        sv(miniPlayerView, maximizedStackView)
        maximizedStackView.fillHorizontally(m: 24).bottom(24)
        maximizedStackView.Top == safeAreaLayoutGuide.Top + 24
        imageView.heightEqualsWidth()
        imageView.transform = shrinkTransform
        miniPlayerView.fillHorizontally().top(0).height(100)
    }

    //MARK:- Slider
    private func setupSlider() {
        observePlayerCurrentTime()
        progressSliderView.slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }

    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.progressSliderView.elapsedTimeLabel.text = time.toDisplayString()
            let duration = self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)
            let timeRemaining = CMTimeSubtract(duration, time)
            self?.progressSliderView.totalTimeLabel.text = "-\(timeRemaining.toDisplayString())"
            self?.updateSlider(time, duration)
        }
    }

    private func updateSlider(_ time: CMTime, _ duration: CMTime) {
        let percentage = CMTimeGetSeconds(time) / CMTimeGetSeconds(duration)
        self.progressSliderView.slider.value = Float(percentage)
    }

    @objc func sliderValueChanged(_ slider: UISlider) {
        let percentage = slider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let targetTimeInSeconds = Float64(percentage) * durationInSeconds
        let targetTime = CMTimeMakeWithSeconds(targetTimeInSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        player.seek(to: targetTime)
    }

    //MARK:- Player Controls
    private let shrinkTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)

    private func setupControls() {
        controlsView.rewindButton.addTarget(self, action: #selector(handleRewind), for: .touchUpInside)
        controlsView.playButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        miniPlayerView.playButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        controlsView.forwardButton.addTarget(self, action: #selector(handleForward), for: .touchUpInside)
        miniPlayerView.forwardButton.addTarget(self, action: #selector(handleForward), for: .touchUpInside)
        volumeSliderView.slider.addTarget(self, action: #selector(handleVolumeChange(_:)), for: .valueChanged)
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in
            self?.enlargeImageView()
        }
    }

    @objc func handleRewind() {
        seekToTime(-15)
    }

    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            controlsView.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayerView.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeImageView()
        } else {
            player.pause()
            controlsView.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayerView.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkImageView()
        }
    }

    @objc func handleForward() {
        seekToTime(15)
    }

    private func seekToTime(_ delta: Int64) {
        let currentTime = player.currentTime()
        let deltaTime = CMTimeMake(value: delta, timescale: 1)
        let targetTime = CMTimeAdd(currentTime, deltaTime)
        player.seek(to: targetTime)
    }

    private func enlargeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.imageView.transform = .identity
        })
    }

    private func shrinkImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.imageView.transform = self.shrinkTransform
        })
    }

    //MARK:- Volume Slider
    @objc func handleVolumeChange(_ slider: UISlider) {
        player.volume = slider.value
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
