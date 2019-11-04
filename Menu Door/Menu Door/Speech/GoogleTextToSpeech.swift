//
//  GoogleTextToSpeech.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/27/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//

import Foundation
import AVFoundation

internal class GoogleTextToSpeech: NSObject, AVAudioPlayerDelegate {
    
    static let shared = GoogleTextToSpeech()
    private var player: AVAudioPlayer?
    
    private enum VoiceType: String {
        case undefined
        case waveNetFemale = "en-US-Wavenet-F"
        case waveNetMale = "en-US-Wavenet-D"
        case standardFemale = "en-US-Standard-E"
        case standardMale = "en-US-Standard-D"
    }
    private let ttsAPIUrl = "https://texttospeech.googleapis.com/v1/text:synthesize"
    private let APIKey = "AIzaSyCm6o_5vHO9dGgVA-onkJIQJXmyGjIf_Pc"
    private let rate: Float = 1
    private let pitch: Float = 0
    private var busy: Bool = false
    
    internal func speak(_ dish: String) {
        if busy { return }
        busy = true
        let JSONData: Data = buildPostData(dish: dish)
        guard let urlRequest = createURLRequest(JSONdata: JSONData, dish: dish) else {
            notWorking(dish: dish)
            return
        }
        sendPOSTRequest(httpRequest: urlRequest, dish: dish)
    }
    
    private func buildPostData(dish: String) -> Data {
        let params: [String: Any] = [
            "input": [
                "text": dish
            ],
            "voice": [
                "languageCode": "en-US",
                "name": VoiceType.waveNetFemale.rawValue
            ],
            "audioConfig": [
                "audioEncoding": "LINEAR16",
                "pitch": pitch,
                "speakingRate": rate
            ]
        ]
        
        // Convert the Dictionary to Data
        let data = try! JSONSerialization.data(withJSONObject: params)
        return data
    }
    
    // The following method creates a request that will send a POST request in JSON form
    private func createURLRequest(JSONdata: Data, dish: String) -> URLRequest? {
        guard let url = URL(string: ttsAPIUrl) else {
            notWorking(dish: dish)
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(APIKey, forHTTPHeaderField: "X-Goog-Api-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("utf-8", forHTTPHeaderField: "charset")
        request.httpBody = JSONdata
        return request
    }
    
    private func sendPOSTRequest(httpRequest: URLRequest, dish: String) {
        // The following block sends username and then receives registration request from server
        URLSession.shared.dataTask(with: httpRequest) { (data, response, error) in
            guard let data = data else {
                self.notWorking(dish: dish)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                self.notWorking(dish: dish)
                return
            }
            guard let audioContent: String = json["audioContent"] as? String else {
                self.notWorking(dish: dish)
                return
            }
            guard let audioData = Data(base64Encoded: audioContent, options: .ignoreUnknownCharacters) else {
                self.notWorking(dish: dish)
                return
            }
            AnalyticsWrapper.Speech.sendAnalytics(method: AnalyticsWrapper.Speech.Method.Google, success: true, googleTried: true)
            self.playTheAudioContent(audioData: audioData)
        }.resume()
    }
    
    // This function plays the audio content
    private func playTheAudioContent(audioData: Data) {
        DispatchQueue.main.async {
            self.player = try! AVAudioPlayer(data: audioData)
            self.player?.delegate = self
            self.player!.play()
        }
    }
    
    // This is used to make sure that when speaker is done playing the sound, previous music that
    // was playing starts again
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let audio: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try audio.setActive(false, options: .notifyOthersOnDeactivation)
        } catch  {
            return
        }
        busy = false
    }
    
    // If google speech to text does not work then use apple speech to text
    func notWorking(dish: String) {
        AppleTextToSpeech.speak(dish, googleTriedFirst: true)
        busy = false
    }
}
