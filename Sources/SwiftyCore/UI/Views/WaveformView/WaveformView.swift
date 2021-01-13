//
//  WaveformView.swift
//  
//
//  Created by Borko Tomic on 13.1.21..
//

import Foundation
import AVFoundation
import Accelerate
import UIKit


enum WaveformStyle {
    case bars
    case barsCentered
    case wave
}

class WaveformView : UIView {
    
    private let pixelWidth: CGFloat = 2.0
    private let pixelSpacing: CGFloat = 2.0
    private var waveColor: UIColor = .lightGray
    private var pastWaveColor: UIColor = .black
    
    private var style: WaveformStyle = .barsCentered {
        didSet {
            self.reload()
        }
    }
    
    private var currentProgress: Double = 0.0 {
        didSet {
            reload()
        }
    }

    private var floatValuesLeft = [Float]()
    private var leftPoints = [CGPoint]()
    private var populated = false
    
    public convenience init(style: WaveformStyle = .barsCentered, baseColor: UIColor = .lightGray, pastColor: UIColor = .darkGray) {
        self.init()
        
        self.waveColor = baseColor
        self.pastWaveColor = pastColor
        self.style = style
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear
    }
    
    public func openFile(_ file: URL) {
        guard let audioFile = try? AVAudioFile(forReading: file) else {
            print("Sound file can not be opened for reading")
            return
        }
        
        // specify the format we WANT for the buffer
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: audioFile.fileFormat.sampleRate, channels: audioFile.fileFormat.channelCount, interleaved: false)
        
        // initialize and fill the buffer
        let buffer = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: UInt32(audioFile.length))
        try! audioFile.read(into: buffer!)
        
        // copy buffer to readFile struct
        let array = Array(UnsafeBufferPointer(start: buffer?.floatChannelData?[0], count:Int(buffer!.frameLength)))
        var absoluteArray = [Float](repeating: 0.0,count: array.count)
        vDSP_vabs(array, 1, &absoluteArray, 1, vDSP_Length(array.count))
        floatValuesLeft = absoluteArray
        populated = false
        
        reload()
    }
    
    public func setProgress(percent: Double) {
        currentProgress = percent
    }
    
    public func reload() {
        setNeedsDisplay()
    }
    
    public func makePoints(completion: @escaping () -> Void) {
        if populated { return }
        
        let viewWidth = DispatchQueue.main.sync {
            self.bounds.width
        }
        let sampleCount = floatValuesLeft.count
        
        // grab every nth sample (samplesPerPixel)
        let samplesPerPixel = Int(floor(Float(sampleCount) / Float(viewWidth)))
        
        let reducedSampleCount = sampleCount / samplesPerPixel
    
        var maxSamplesBuffer = [Float](repeating: 0.0, count: reducedSampleCount)
        var offset = 0
        for i in stride(from: 0, to: sampleCount-samplesPerPixel, by: samplesPerPixel) {
            maxSamplesBuffer[offset] = floatValuesLeft[i...i+samplesPerPixel].max() ?? 0.0
            offset = offset + 1
        }
        // Convert the maxSamplesBuffer values to CGPoints for drawing
        // We also normalize them for display here
        leftPoints = maxSamplesBuffer.enumerated().map({ (index, value) -> CGPoint in
            let normalized = normalizeForDisplay(value)
            let point = CGPoint(x: CGFloat(index), y: CGFloat(normalized))
            return point
        })
        populated = true
        
        DispatchQueue.main.async {
            self.reload()
            completion()
        }
    }
    
    func drawDetailedWaveform(_ rect: CGRect) {
        for (index, point) in leftPoints.enumerated() {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0, y: rect.height/2))
            let drawFrom = CGPoint(x: point.x, y: path.currentPoint.y)
            path.move(to: drawFrom)
            
            // bottom half
            let drawPointBottom = CGPoint(x: point.x, y: path.currentPoint.y + (point.y))
            path.addLine(to: drawPointBottom)
            path.close()
            
            // top half
            let drawPointTop = CGPoint(x: point.x, y: path.currentPoint.y - (point.y))
            path.addLine(to: drawPointTop)
            path.close()
            
            let color = getColor(for: index)
            color.set()
            path.stroke()
            path.fill()
        }
    }
    
    func drawBarsWaveform(_ rect: CGRect) {
        var index = 0
        let startingY = style == .barsCentered ? rect.height/2 : rect.height
        while index < leftPoints.count {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0, y: startingY))
            let point = leftPoints[index]
            let drawFrom = CGPoint(x: point.x, y: path.currentPoint.y)
            
            // bottom half
            path.move(to: drawFrom)
            let drawPointBottom = CGPoint(x: point.x, y: path.currentPoint.y + (point.y))
            path.addLine(to: drawPointBottom)
            path.addLine(to: CGPoint(x: drawPointBottom.x + pixelWidth, y: drawPointBottom.y))
            path.addLine(to: CGPoint(x: drawFrom.x + pixelWidth, y: drawFrom.y))
            path.close()
            
            // top half
            path.move(to: drawFrom)
            let drawPointTop = CGPoint(x: point.x, y: path.currentPoint.y - (point.y))
            path.addLine(to: drawPointTop)
            path.addLine(to: CGPoint(x: drawPointTop.x + pixelWidth, y: drawPointTop.y))
            path.addLine(to: CGPoint(x: drawFrom.x + pixelWidth, y: drawFrom.y))
            path.close()
            
            // increment index
            index = index + Int(pixelWidth) + Int(pixelSpacing)
            
            let color = getColor(for: index)
            color.set()
            path.stroke()
            path.fill()
        }
    }
    
    private func getColor(for index: Int) -> UIColor {
        return currentProgress/100.0 > Double(index)/Double(leftPoints.count) ? pastWaveColor : waveColor
    }
    
    override public func draw(_ rect: CGRect) {
        //makePoints()
        
        backgroundColor = .clear
        switch style {
        case .barsCentered, .bars:
            drawBarsWaveform(rect)
        case .wave:
            drawDetailedWaveform(rect)
        }
    }
    
    private func normalizeForDisplay(_ value: Float) -> Float {
        let viewHeight = DispatchQueue.main.sync {
            self.bounds.height
        }
        switch style {
        case .barsCentered, .wave:
            return Float(viewHeight)/2*value
        case .bars:
            return Float(viewHeight)*value
        }
    }
}
