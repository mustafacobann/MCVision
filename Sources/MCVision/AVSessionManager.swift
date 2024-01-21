//
//  AVSessionManager.swift
//  Created by Mustafa on 22.01.2024.
//

import Foundation
import AVFoundation

public final class AVSessionManager: NSObject, ObservableObject {
    var session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session_queue")
    private let outputQueue = DispatchQueue(label: "output_queue")

    var delegate: MCVisionViewDelegate?

    override init() {
        super.init()
        Task {
            let isAuthorizationGranted = await checkAuthorization()
            if isAuthorizationGranted {
                sessionQueue.async { [weak self] in
                    self?.setup()
                }
            }
        }
    }

    func checkAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        case .authorized:
            return true
        default:
            return false
        }
    }

    func setup() {
        do {
            session.beginConfiguration()

            guard let videoDevice = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .front
            ).devices.first
            else {
                fatalError()
            }

            let input = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(input) {
                session.addInput(input )
            }

            let output = AVCaptureVideoDataOutput()
            if session.canAddOutput(output) {
                output.setSampleBufferDelegate(self, queue: outputQueue)
                output.videoSettings = [
                    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
                ]
                session.addOutput(output)
            }

            session.commitConfiguration()
            session.startRunning()
        } catch {
            session.commitConfiguration()
            fatalError()
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension AVSessionManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        delegate?.didReceiveSampleBuffer(sampleBuffer)
    }
}
