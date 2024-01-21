//
//  MCVisionViewDelegate.swift
//  Created by Mustafa on 22.01.2024.
//

import AVFoundation

public protocol MCVisionViewDelegate {
    func didReceiveSampleBuffer(_ sampleBuffer: CMSampleBuffer)
}
