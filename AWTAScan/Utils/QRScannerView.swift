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
        
        // Set up camera preview layer with a margin
        let margin: CGFloat = 20  // Adjust the margin size
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.videoGravity = .resizeAspectFill
        
        let previewFrame = CGRect(
            x: margin,
            y: margin,
            width: bounds.width - (margin * 2),
            height: bounds.height - (margin * 2)
        )
        
        previewLayer.frame = previewFrame
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
        let cornerSize: CGFloat = 30
        let lineWidth: CGFloat = 6
        let inset: CGFloat = 8 // Distance from preview frame
        let cornerColor = UIColor.black.cgColor

        let previewFrame = previewLayer.frame // Get the preview layer's frame

        let path = UIBezierPath()

        // Top-left corner (outside)
        path.move(to: CGPoint(x: previewFrame.minX - inset, y: previewFrame.minY - inset + cornerSize))
        path.addLine(to: CGPoint(x: previewFrame.minX - inset, y: previewFrame.minY - inset))
        path.addLine(to: CGPoint(x: previewFrame.minX - inset + cornerSize, y: previewFrame.minY - inset))

        // Top-right corner (outside)
        path.move(to: CGPoint(x: previewFrame.maxX + inset - cornerSize, y: previewFrame.minY - inset))
        path.addLine(to: CGPoint(x: previewFrame.maxX + inset, y: previewFrame.minY - inset))
        path.addLine(to: CGPoint(x: previewFrame.maxX + inset, y: previewFrame.minY - inset + cornerSize))

        // Bottom-left corner (outside)
        path.move(to: CGPoint(x: previewFrame.minX - inset, y: previewFrame.maxY + inset - cornerSize))
        path.addLine(to: CGPoint(x: previewFrame.minX - inset, y: previewFrame.maxY + inset))
        path.addLine(to: CGPoint(x: previewFrame.minX - inset + cornerSize, y: previewFrame.maxY + inset))

        // Bottom-right corner (outside)
        path.move(to: CGPoint(x: previewFrame.maxX + inset - cornerSize, y: previewFrame.maxY + inset))
        path.addLine(to: CGPoint(x: previewFrame.maxX + inset, y: previewFrame.maxY + inset))
        path.addLine(to: CGPoint(x: previewFrame.maxX + inset, y: previewFrame.maxY + inset - cornerSize))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = cornerColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        layer.addSublayer(shapeLayer)
    }


    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
        layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        setupCornerBrackets()
    }
}

