//
//  SpeechManager.swift
//  Todo_with_chatbot
//
//  Created by MANINDER SINGH on 27/04/20.
//  Copyright © 2020 MANINDER SINGH. All rights reserved.
//

import Foundation
import Speech

protocol SpeechManagerDelegate
{
    func didReceiveText(text:String)
    func didStartedListening(status:Bool)
}

class SpeechManager
{
    lazy var speechSynthesizer = AVSpeechSynthesizer()
   
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    let audioSession = AVAudioSession.sharedInstance()
    var delegate:SpeechManagerDelegate?
    
    static let shared:SpeechManager = {
        let instance = SpeechManager()
        return instance
    }()
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.record)))
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        request = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode as? AVAudioInputNode
            else {
                fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = request as? SFSpeechAudioBufferRecognitionRequest
            else {
                fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.delegate?.didReceiveText(text: (result?.bestTranscription.formattedString)!)
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        delegate?.didStartedListening(status: true)
        
    }
    
    func stopRecording()
    {
        if audioEngine.isRunning
        {
            audioEngine.stop()
            request.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
    }
    
    func speak(text: String) {
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)))
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}
