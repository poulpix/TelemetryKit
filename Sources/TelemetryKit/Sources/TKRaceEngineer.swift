//
//  TKRaceEngineer.swift
//  TelemetryKit
//
//  Created by Romain on 31/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation
import AVFoundation
#if os(iOS)
import Speech
#endif

public enum TKRaceEngineerQueryIntent: String, Codable {
	
	case none = "None"
	case driverInfo = "Driver info"
	case teamInfo = "Team info"
	case positionInfo = "Position info"

}

internal class TKRaceEngineer: NSObject {
	
	var delegate: TKInternalVoiceDelegate?
	var utterancesToSpeak: [String]
	var radioSoundPlayer: AVAudioPlayer
	#if os(iOS)
	let audioEngine: AVAudioEngine
	let speechRecognizer: SFSpeechRecognizer
	let request: SFSpeechAudioBufferRecognitionRequest
	var recognitionTask: SFSpeechRecognitionTask?
	let synthesizer: AVSpeechSynthesizer
	var utterancesPlaylist: [AVSpeechUtterance]
	
	private static var _britishVoice: AVSpeechSynthesisVoice!
	static var britishVoice: AVSpeechSynthesisVoice {
		if _britishVoice == nil {
			let enGBVoices = AVSpeechSynthesisVoice.speechVoices().filter { $0.identifier == "com.apple.ttsbundle.Daniel-premium" }
			_britishVoice = (enGBVoices.count > 0) ? enGBVoices.first! : AVSpeechSynthesisVoice(language: "en-GB")!
		}
		return _britishVoice
	}
	#endif

	#if os(macOS)
	override init() {
		utterancesToSpeak = [String]()
		radioSoundPlayer = AVAudioPlayer()
		super.init()
		do {
			radioSoundPlayer = try AVAudioPlayer(contentsOf: TKResources.resourceURL(named: "F1Radio", ofType: .sound))
			radioSoundPlayer.delegate = self
		} catch let error {
			print("🔕 Error while initializing F1 radio sound: \(error)")
		}
	}
	#endif
	
	#if os(iOS)
	override init() {
		utterancesToSpeak = [String]()
		radioSoundPlayer = AVAudioPlayer()
		audioEngine = AVAudioEngine()
		speechRecognizer = SFSpeechRecognizer()!
		request = SFSpeechAudioBufferRecognitionRequest()
		synthesizer = AVSpeechSynthesizer()
		utterancesPlaylist = [AVSpeechUtterance]()
		super.init()
		synthesizer.delegate = self
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback)
			try AVAudioSession.sharedInstance().setActive(true)
			radioSoundPlayer = try AVAudioPlayer(contentsOf: TKResources.resourceURL(named: "F1Radio", ofType: .sound))
			radioSoundPlayer.delegate = self
		} catch let error {
			print("🔕 Error while initializing F1 radio sound: \(error)")
		}
	}
		
	func requestAuthorization() {
		SFSpeechRecognizer.requestAuthorization { [unowned self] (authStatus) in
			switch authStatus {
			case .authorized:
				do {
					try self.startRecording()
				} catch let error {
					print("There was a problem starting recording: \(error.localizedDescription)")
				}
			case .denied:
				print("Speech recognition authorization denied")
			case .restricted:
				print("Not available on this device")
			case .notDetermined:
				print("Not determined")
			@unknown default:
				print("Not determined")
			}
		}
	}
	
	func startRecording() throws {
		let audioSession = AVAudioSession.sharedInstance()
		try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
		try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
		let node = audioEngine.inputNode
		let recordingFormat = node.outputFormat(forBus: 0)
		node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [unowned self] (buffer, _) in
			self.request.append(buffer)
		}
		audioEngine.prepare()
		try audioEngine.start()
		recognitionTask = speechRecognizer.recognitionTask(with: request) { [unowned self] (result, _) in
			if let transcription = result?.bestTranscription {
				self.fetchLUISntent(query: transcription.formattedString)
			}
			if result?.isFinal ?? false {
				self.stopRecording()
			}
		}
	}
	
	func stopRecording() {
		audioEngine.inputNode.removeTap(onBus: 0)
		audioEngine.stop()
		request.endAudio()
		recognitionTask?.cancel()
	}
	#endif

	func fetchLUISntent(query: String) {
		let session = URLSession.shared
		let queryParams: [String: String] = [
			"verbose": "true",
			"timezoneOffset": "60",
			"subscription-key": "b6321bce091a4de4adaf15775d997b36",
			"q": query
		]
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = "westeurope.api.cognitive.microsoft.com"
		urlComponents.path = "/luis/v2.0/apps/28db195a-7d30-424c-bf67-ae016d405d5c"
		urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
		let task = session.dataTask(with: urlComponents.url!) { data, response, error in
			if error != nil {
				self.delegate?.playerVoiceTranscription(query, didFailWithError: error!)
				return
			}
			guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
					self.delegate?.playerVoiceTranscription(query, didFailWithError: TKLUISError.httpCodeError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0))
					return
			}
			guard let mime = response?.mimeType, mime == "application/json" else {
				self.delegate?.playerVoiceTranscription(query, didFailWithError: TKLUISError.mimeTypeError(mimeType: response?.mimeType ?? ""))
				return
			}
			do {
				let luisResponse = try JSONDecoder().decode(TKLUISResponse.self, from: data!)
				self.delegate?.playerVoiceTranscription(query, didReturnLUISResponse: luisResponse)
				try self.handleLUISIntent(luisResponse)
			} catch {
				self.delegate?.playerVoiceTranscription(query, didFailWithError: error)
			}
		}
		task.resume()
	}
	
	func handleLUISIntent(_ response: TKLUISResponse) throws {
		switch response.topScoringIntent.intent {
		case .driverInfo:
			guard let driverName = response.firstEntity(ofType: .driver), let driver = TKDriver.driver(withFullName: driverName.identifier) else {
				throw TKLUISError.intentHandlingError(intent: response.topScoringIntent.intent)
			}
			delegate?.playerAskedFor(driverInfo: driver)
		case .teamInfo:
			guard let teamName = response.firstEntity(ofType: .team), let team = TKTeam.team(withFullName: teamName.identifier) else {
				throw TKLUISError.intentHandlingError(intent: response.topScoringIntent.intent)
			}
			delegate?.playerAskedFor(teamInfo: team)
		case .positionInfo:
			guard let positionStr = response.firstEntity(ofType: .position), let position = TKPosition(rawValue: Int8(positionStr.identifier)!) else {
				throw TKLUISError.intentHandlingError(intent: response.topScoringIntent.intent)
			}
			delegate?.playerAskedFor(positionInfo: position)
		case .none:
			break
		}
	}

	func makeRaceEngineerSpeak(utterances: [String]) {
		delegate?.raceEngineerWillSay(utterances: utterances)
		utterancesToSpeak.append(contentsOf: utterances)
		#if os(iOS)
		if utterancesPlaylist.count == 0 {
			radioSoundPlayer.play()
		} else {
			internalMakeRaceEngineerSpeak()
		}
		#endif
		#if os(macOS)
		radioSoundPlayer.play()
		#endif
	}
	
}

#if os(iOS)
extension TKRaceEngineer: AVSpeechSynthesizerDelegate {
	
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		utterancesPlaylist.removeFirst()
	}
	
}
#endif

extension TKRaceEngineer: AVAudioPlayerDelegate {
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		internalMakeRaceEngineerSpeak()
	}
	
	private func internalMakeRaceEngineerSpeak() {
		#if os(iOS)
		let speechUtterances = utterancesToSpeak.map { return AVSpeechUtterance(string: $0) }
		speechUtterances.forEach {
			$0.voice = TKRaceEngineer.britishVoice
			// TODO: for more accurate speaking of drivers and teams, see: https://nshipster.com/avspeechsynthesizer/
			utterancesPlaylist.append($0)
			utterancesToSpeak.removeFirst()
			synthesizer.speak($0)
		}
		#endif
		#if os(macOS)
		utterancesToSpeak.removeAll()
		#endif
	}
	
}
