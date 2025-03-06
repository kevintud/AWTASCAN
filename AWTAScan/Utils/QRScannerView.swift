//
//  QRScannerView.swift
//  AWTAScan
//
//  Created by Kevin on 3/5/25.



import UIKit
import AVFoundation

protocol QRScannerViewDelegate: AnyObject {
    func didScan(code: String)
}

class QRScannerView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: QRScannerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScanner()
        setupCornerBrackets() // Add corner brackets
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScanner()
        setupCornerBrackets() // Add corner brackets
    }
    
    private func setupScanner() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to access the camera.")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Failed to create video input.")
            return
        }
        
        if captureSession!.canAddInput(videoInput) {
            captureSession!.addInput(videoInput)
        } else {
            print("Failed to set input device.")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession!.canAddOutput(metadataOutput) {
            captureSession!.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Failed to set output.")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = self.bounds
        layer.addSublayer(previewLayer)
        
        captureSession!.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first,
           let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {
            
            delegate?.didScan(code: stringValue)
        }
    }
    
    func restartScanning() {
        if captureSession?.isRunning == false {
            captureSession?.startRunning()
        }
    }
    
    func startScanning() {
        captureSession?.startRunning()
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
    }
    
    // MARK: - Corner Brackets
    private func setupCornerBrackets() {
        let cornerSize: CGFloat = 20
        let lineWidth: CGFloat = 4
        let cornerColor = UIColor.purple.cgColor
        let blackCornerColor = UIColor.black.cgColor
        
        let path = UIBezierPath()
        
        // Top-left corner
        path.move(to: CGPoint(x: 0, y: cornerSize))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: cornerSize, y: 0))
        
        // Top-right corner
        path.move(to: CGPoint(x: bounds.width - cornerSize, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: cornerSize))
        
        // Bottom-left corner
        path.move(to: CGPoint(x: 0, y: bounds.height - cornerSize))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.addLine(to: CGPoint(x: cornerSize, y: bounds.height))
        
        // Bottom-right corner
        path.move(to: CGPoint(x: bounds.width - cornerSize, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height - cornerSize))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = cornerColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        layer.addSublayer(shapeLayer)
        
        let blackShapeLayer = CAShapeLayer()
        blackShapeLayer.path = path.cgPath
        blackShapeLayer.strokeColor = blackCornerColor
        blackShapeLayer.fillColor = UIColor.clear.cgColor
        blackShapeLayer.lineWidth = lineWidth - 1
        layer.addSublayer(blackShapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
        layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        setupCornerBrackets()
    }
}

