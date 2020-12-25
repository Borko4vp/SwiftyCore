//
//  File.swift
//  
//
//  Created by Borko Tomic on 25.12.20..
//

import AVFoundation
import UIKit

class VoiceMessageView: UIView {
    class func instanceFromNib(with frame: CGRect) -> VoiceMessageView {
        let xibView = SwiftyCore.UI.InternalViews.Nibs.voiceMessageView.instantiate(withOwner: self, options: nil)[0] as! VoiceMessageView
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        xibView.frame = frame
        xibView.setNeedsLayout()
        xibView.layoutIfNeeded()
        return xibView
    }
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressViewPlaceholder: UIView!
    
    private var progressView: ProgressView?
    private var recording: URL?
    private var localRecording: URL? {
        guard let id = id else { return nil }
        return FileHelper.getLocalUrl(for: id)
    }
    private var id: String?
    private var audioPlayer: AVAudioPlayer?
    private var playbackTimer: Timer?
    private var isPlaying: Bool = false {
        didSet {
            setButtonUi()
        }
    }
    
    
    public func set(with url: URL, and id: String) {
        recording = url
        self.id = id
        isPlaying = false
        progressView = ProgressView.instanceFromNib(with: progressViewPlaceholder.bounds)
        guard let progressView = progressView else { return }
        progressViewPlaceholder.addSubview(progressView)
        DispatchQueue.main.async {
            progressView.setProgress(percent: 0)
        }
        download {
            self.preparePlayer()
        }
        setNeedsLayout()
    }
    
    private func setButtonUi() {
        let image = isPlaying ? Image.circleStop.uiImage : Image.circlePlay.uiImage
        playButton.setImage(image, for: .normal)
        playButton.tintColor = .lightGray
    }
    
    @IBAction private func playButtonAction(_ sender: UIButton) {
        isPlaying.toggle()
        if isPlaying {
            download {
                self.preparePlayer()
                self.playRecording()
            }
        } else {
            stopPlayingRecording()
        }
    }
    
    private func download(completion: @escaping () -> Void) {
        guard let id = id, let recoringUrl = recording, let local = localRecording else {
            completion ()
            return
        }
        if !FileHelper.recordingExists(for: id) {
            activityIndicator.startAnimating()
            URLSession.shared.download(from: recoringUrl, to: local) { success in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                completion()
                guard success else { return }
                print("downloaded remote audio url")
            }
        } else {
            completion()
        }
    }
    
    private func preparePlayer() {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        guard let  url = localRecording, let player = try? AVAudioPlayer(contentsOf: url) else {
            print("prepare player failed")
            return
        }
        audioPlayer = player
        audioPlayer?.prepareToPlay()
        audioPlayer?.delegate = self
        audioPlayer?.volume = 1.0
        
        updateTimeLabels()
    }
    
    private func updateTimeLabels() {
        let totalTime: Int = Int(audioPlayer?.duration.rounded(.up) ?? 0)
        let minutes = totalTime/60 < 10 ? "0\(totalTime/60)" : "\(totalTime/60)"
        let seconds = totalTime%60 < 10 ? "0\(totalTime%60)" : "\(totalTime%60)"
        endTimeLabel.text = minutes + ":" + seconds
    }
    
    func playRecording() {
        audioPlayer?.play()
        startProgressTimer()
    }
    
    func stopPlayingRecording() {
        audioPlayer?.stop()
        audioPlayer = nil
        stopProgressTimer()
        isPlaying = false
    }
    
    private func startProgressTimer() {
        DispatchQueue.main.async {
            self.playbackTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
        }
    }
    
    private func stopProgressTimer() {
        playbackTimer?.invalidate()
        playbackTimer = nil
        progressView?.setProgress(percent: 0)
    }
    
    @objc
    private func updateProgress() {
        let total: Double = audioPlayer?.duration ?? 0.0
        let current: Double = audioPlayer?.currentTime ?? 0.0
        
        progressView?.setProgress(percent: current/total*100)
    }
}

extension VoiceMessageView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopPlayingRecording()
    }
}
