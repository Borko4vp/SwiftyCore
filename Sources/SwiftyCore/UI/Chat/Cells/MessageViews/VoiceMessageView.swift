//
//  File.swift
//  
//
//  Created by Borko Tomic on 25.12.20..
//

import AVFoundation
import UIKit

public enum VoiceMessageProgressType {
    case bar
    case waveformBars
    case waveformBarsCentered
    case waveform
    
    var waveformStyle: WaveformStyle? {
        switch self {
        case .bar: return nil
        case .waveformBars: return .bars
        case .waveformBarsCentered: return .barsCentered
        case .waveform: return .wave
        }
    }
}

class VoiceMessageView: UIView {
    class func instanceFromNib(with frame: CGRect) -> VoiceMessageView {
        let xibView = SwiftyCore.UI.InternalViews.Nibs.voiceMessageView.instantiate(withOwner: self, options: nil)[0] as! VoiceMessageView
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        xibView.frame = frame
        xibView.setNeedsLayout()
        xibView.layoutIfNeeded()
        return xibView
    }
    @IBOutlet private weak var playButton: UIButton!
    
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var progressBarViewPlaceholder: UIView!
    
    @IBOutlet private weak var progressViewPlaceholder: UIView!
    @IBOutlet private weak var waveformViewPlaceholder: UIView!
    
    private var initializationGroup: DispatchGroup = DispatchGroup()
    private var style: VoiceMessageProgressType?
    private var progressView: SwiftyCore.UI.ProgressView?
    private var waveform: WaveformView?
    private var recording: URL?
    private var localRecording: URL? {
//        guard let id = id else { return nil }
//        return FileHelper.getLocalUrl(for: id)
        return Bundle.main.url(forResource: "Intro", withExtension: "mp4")
    }
    private var id: String?
    private var audioPlayer: AVAudioPlayer?
    private var playbackTimer: Timer?
    private var isPlaying: Bool = false {
        didSet {
            setButtonUi()
        }
    }
    
    
    public func set(with url: URL, and id: String, type: VoiceMessageProgressType) {
        self.style = type
        progressViewPlaceholder.isHidden = type != .bar
        waveformViewPlaceholder.isHidden = type == .bar
        recording = url
        self.id = id
        isPlaying = false
        progressView = SwiftyCore.UI.ProgressView(rect: progressBarViewPlaceholder.bounds, color:  .darkGray, backColor: .lightGray)
        if let view = progressView?.view, progressBarViewPlaceholder.subviews.isEmpty {
            progressBarViewPlaceholder.addSubview(view)
        }
        //download {
        guard let local = localRecording else { fatalError() }
        if let style = style, style != .bar, let waveStyle = style.waveformStyle {
            DispatchQueue.main.async {
                for subview in self.waveformViewPlaceholder.subviews {
                    subview.removeFromSuperview()
                }
                let view = WaveformView(style: waveStyle, baseColor: .blue, pastColor: .green)
                view.frame = self.waveformViewPlaceholder.bounds
                view.backgroundColor = .white
                self.waveformViewPlaceholder.addSubview(view)
                self.waveform = view
                self.waveform?.openFile(local)
                DispatchQueue.global(qos: .background).async {
                    self.waveform?.makePoints() {
                        self.preparePlayer()
                    }
                }
            }
        } else {
            self.preparePlayer()
        }

            
        //}
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
                self.waveform?.openFile(recoringUrl)
                guard success else { return }
                print("downloaded remote audio url")
            }
        } else {
            waveform?.openFile(recoringUrl)
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
        
        DispatchQueue.main.async {
            self.updateTimeLabels()
        }
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
        waveform?.setProgress(percent: 0)
    }
    
    @objc
    private func updateProgress() {
        let total: Double = audioPlayer?.duration ?? 0.0
        let current: Double = audioPlayer?.currentTime ?? 0.0
        
        if style == .bar {
            progressView?.setProgress(percent: current/total*100)
        } else {
            waveform?.setProgress(percent: current/total*100)
        }
    }
}

extension VoiceMessageView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopPlayingRecording()
    }
}
