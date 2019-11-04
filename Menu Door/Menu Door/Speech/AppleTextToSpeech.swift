//
//  AppleTextToSpeech.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/18/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  This class is used to do speech to text from Apple

import AVFoundation

internal class AppleTextToSpeech {
    
    private static let synthesizer = AVSpeechSynthesizer()
    private static let rate: Float = 0.4
    
    static func speak(_ dish: String, googleTriedFirst: Bool) {
        AnalyticsWrapper.Speech.sendAnalytics(method: AnalyticsWrapper.Speech.Method.Apple, success: true, googleTried: googleTriedFirst)
        
        let utterance = AVSpeechUtterance(string: dish)
        utterance.rate = rate
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}
