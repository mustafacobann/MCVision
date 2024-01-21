//
//  MCVisionView.swift
//  Created by Mustafa on 22.01.2024.
//

import SwiftUI
import AVFoundation

public struct MCVisionView: UIViewRepresentable {
    private let sessionManager: AVSessionManager

    public init(delegate: MCVisionViewDelegate) {
        sessionManager = AVSessionManager()
        sessionManager.delegate = delegate
    }

    public func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: sessionManager.session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {}
}
