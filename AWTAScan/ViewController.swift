//
//  ViewController.swift
//  LAMPQRReader
//
//  Created by Kevin Lloyd Tud on 9/22/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var fetchedData: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a background queue for AVCaptur/Users/kevin/Desktop/Projects/Apps/AWTAScan/AWTAScan/ProfileViewController.swifteSession
        let sessionQueue = DispatchQueue(label: "com.yourapp.AVCaptureSessionQueue")
        
        sessionQueue.async {
            self.captureSession = AVCaptureSession()
            
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
            
            if self.captureSession.canAddInput(videoInput) {
                self.captureSession.addInput(videoInput)
            } else {
                print("Failed to set input device.")
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if self.captureSession.canAddOutput(metadataOutput) {
                self.captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                print("Failed to set output.")
                return
            }
            
            DispatchQueue.main.async {
                self.setupPreviewLayer()
                self.captureSession.startRunning()
            }
        }
    }

    func setupPreviewLayer() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer.frame = self.view.layer.bounds
        self.view.layer.addSublayer(self.previewLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            // Fetch data for the delegate
            fetchData(delegateID: stringValue)
        }
    }
    
    func fetchData(delegateID: String) {
        // Construct the URL with the delegateID
        let baseURL = "https://online.lampawta.com/api/delegate/"
        let apiKey = "bdf0bf18-54cf-4aca-86ec-a03b77c02264"
        
        guard let url = URL(string: "\(baseURL)\(delegateID)?api_key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Store the fetched data
                        self?.fetchedData = json
                        
                        // Trigger the segue to navigate to ProfileViewController
                        DispatchQueue.main.async {
                            self?.performSegue(withIdentifier: "showProfileView", sender: nil)
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileView" {
            if let profileVC = segue.destination as? ProfileViewController {
                // Pass the fetched data to ProfileViewController
                profileVC.fetchedData = self.fetchedData
            }
        }
    }
}
