//
//  TKLiveSessionInfo.swift
//  TelemetryKit
//
//  Created by Romain on 14/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation
import Combine

public class TKLiveSessionInfo {
	
	@Published public var participants: [TKParticipantInfo]
	@Published public var raceLeaderReference: [TKRaceLeaderReference]
	@Published public var sessionID: UInt64
	@Published public var weather: TKWeather
	@Published public var trackTemperature: Int8
	@Published public var airTemperature: Int8
	@Published public var totalLaps: UInt8
	@Published public var trackLength: UInt16
	@Published public var sessionType: TKSessionType
	@Published public var trackId: TKTrack
	@Published public var formula: TKFormula
	@Published public var duration: UInt16
	@Published public var timeLeft: UInt16
	@Published public var pitSpeedLimit: UInt8
	@Published public var isGamePaused: Bool
	@Published public var marshalZones: [TKMarshalZone]
	@Published public var safetyCarStatus: TKSafetyCarStatus
	@Published public var isNetworkGame: Bool
	@Published public var liveRankings: [TKSessionRanking]
    @Published public var bestS1Time: Float32
    @Published public var bestS2Time: Float32
    @Published public var bestS3Time: Float32
    @Published public var bestLapTime: Float32

	public var trackTemperatureFormatted: String {
		get { "\(trackTemperature)°C" }
		set {
		}
	}
	
	public var airTemperatureFormatted: String {
		get { "\(airTemperature)°C" }
		set {
		}
	}
	
	public var durationAsString: String {
		get { duration.asSessionDurationString }
		set {
		}
	}
	
	public var timeLeftAsString: String {
		get { timeLeft.asSessionDurationString }
		set {
		}
	}
	
	public var trackLengthInKm: String {
		get { String(format: "%.3f km", Double(trackLength) / 1000) }
		set {
		}
	}
	
	public var pitSpeedLimitInKph: String {
		get { return "\(pitSpeedLimit) kph" }
		set {
		}
	}
	
	public var numberOfMarshalZones: UInt8 {
		get { return UInt8(marshalZones.count) }
		set {
		}
	}

	private static var _hmsmsDateFormatter: DateFormatter!
	private static var hmsmsDateFormatter: DateFormatter {
		if _hmsmsDateFormatter == nil {
			_hmsmsDateFormatter = DateFormatter()
			_hmsmsDateFormatter.dateFormat = "HH:mm:ss.SSS"
		}
		return _hmsmsDateFormatter
	}
	
	public init() {
		participants = [TKParticipantInfo]()
		raceLeaderReference = [TKRaceLeaderReference]()
		sessionID = 0
		weather = .clear
		trackTemperature = 0
		airTemperature = 0
		totalLaps = 0
		trackLength = 0
		sessionType = .unknown
		trackId = .unknown
		formula = .f1modern
		duration = 0
		timeLeft = 0
		pitSpeedLimit = 0
		isGamePaused = false
		marshalZones = [TKMarshalZone]()
		safetyCarStatus = .noSafetyCar
		isNetworkGame = false
		liveRankings = [TKSessionRanking]()
        bestS1Time = 0
        bestS2Time = 0
        bestS3Time = 0
        bestLapTime = 0
	}
	
	func driver(no driverNo: UInt8) -> TKParticipantInfo? {
		guard driverNo < participants.count else {
			return nil
		}
		return participants[Int(driverNo)]
	}
	
	func driverName(forNo driverNo: UInt8) -> String {
		let d = driver(no: driverNo)
		return (d != nil) ? d!.name : "???"
	}
	
	func gapToLeader(forDriver driver: TKParticipantInfo, at timestamp: Float32) -> Float32 {
		guard let latestInfo = driver.raceStatus.lapTimes.last else {
			return 0
		}
		let leaderReference = raceLeaderReference.filter { $0.lapNo == UInt8(driver.raceStatus.lapTimes.count) }
		for lr in leaderReference {
			if lr.lapDistance >= latestInfo.lapDistance {
				return timestamp - lr.timestamp
			}
		}
		return 0
	}
	
	func liveRankings(at timestamp: Float32) -> [TKSessionRanking] {
		var rankings = [TKSessionRanking]()
		let pCopy = participants.sorted { $0.raceStatus.currentPosition < $1.raceStatus.currentPosition }
		pCopy.forEach {
			rankings.append(TKSessionRanking(participant: $0, driverIndex: participants.index(ofDriver: $0.driverId)!, gapToLeader: gapToLeader(forDriver: $0, at: timestamp)))
		}
		self.liveRankings = rankings
		return rankings
	}
	
	func participant(at index: Range<Array<TKSessionRanking>.Index>.Element) -> TKParticipantInfo {
		return participants[liveRankings[index].driverIndex]
	}

}

extension TKLiveSessionInfo: ObservableObject {
}

extension TKLiveSessionInfo: CustomStringConvertible {
	
	public var description: String { "🛣 \(sessionType.name) session with \(formula.name) on circuit of \(trackId.trackNameAndFlag), weather is \(weather.emojiWeather), air temperature: \(airTemperatureFormatted), track temperature: \(trackTemperatureFormatted)\(isNetworkGame ? " [ONLINE]" : "")" }
	
}

public extension UInt16 {
	
	var asSessionDurationString: String {
		let f = Float32(self)
		let (h, m, s) = (Int(f / 3600), Int(f.truncatingRemainder(dividingBy: 3600) / 60), Int(f.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)))
		return "\(h):\(String(format: "%02d", m)):\(String(format: "%02d", s))"
	}

}

public extension Float32 {
	
	var asLapTimeString: String {
		if self == 0 {
			return ""
		} else {
			let (_, m, s, ms) = (Int(self / 3600), Int(self.truncatingRemainder(dividingBy: 3600) / 60), Int(self.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)), Int(self.truncatingRemainder(dividingBy: 1) * 1000))
			return "\(m > 0 ? "\(m):" : "")\(String(format: ((s >= 10) || (m > 0) ? "%02d" : "%01d"), s)).\(String(format: "%03d", ms))"
		}
	}
	
	var asSectorTimeString: String {
		if self == 0 {
			return "–"
		} else {
			let (_, m, s, ms) = (Int(self / 3600), Int(self.truncatingRemainder(dividingBy: 3600) / 60), Int(self.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)), Int(self.truncatingRemainder(dividingBy: 1) * 1000))
			return "\(m > 0 ? "\(m):" : "")\(String(format: ((s >= 10) || (m > 0) ? "%02d" : "%01d"), s)).\(String(format: "%03d", ms))"
		}
	}
	
	var asSessionTimeString: String {
		let (h, m, s, ms) = (Int(self / 3600), Int(self.truncatingRemainder(dividingBy: 3600) / 60), Int(self.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)), Int(self.truncatingRemainder(dividingBy: 1) * 1000))
		return "\(h):\(String(format: "%02d", m)):\(String(format: "%02d", s)).\(String(format: "%03d", ms))"
	}
	
	var asGapString: String { (self > 0) ? "+\(asLapTimeString)" : "" }
	
	var asSessionTime: Date { Date(timeIntervalSince1970: TimeInterval(exactly: self)!)	}
	
}

public struct TKParticipantInfo {
	
	public var name: String
	public var isAI: Bool
	public var driverId: TKDriver
	public var teamId: TKTeam
	public var raceNumber: UInt8
	public var nationality: TKNationality
	public var carStatus: TKCarStatusInfo
	public var raceStatus: TKRaceStatusInfo

	public init() {
		name = "???"
		isAI = true
		driverId = .localPlayer
		teamId = .mercedes
		raceNumber = 0
		nationality = .unknown
		carStatus = TKCarStatusInfo()
		raceStatus = TKRaceStatusInfo()
	}
	
}

extension TKParticipantInfo: CustomStringConvertible {
	
	public var description: String { "\(nationality.emojiFlag) no \(raceNumber) \(name)\(isAI ? " (AI)" : "") on \(teamId.name)" }
	
}

extension TKParticipantInfo: Identifiable {
	
	public var id: UInt8 { driverId.rawValue }
	
}

public extension Array where Element == TKParticipantInfo {
	
	func index(ofDriver driver: TKDriver) -> Int? {
		for (i, p) in self.enumerated() {
			if p.driverId == driver {
				return i
			}
		}
		return nil
	}
	
}

public struct TKCarStatusInfo {
	
	public var fuelMix: TKFuelMix
	public var tyreCompound: TKTyreVisualCompound
	public var ersDeployMode: TKERSDeploymentMode
	public var vehicleFlags: TKVehicleFIAFlags
	public var frontLeftTyreDamage: UInt8
	public var frontRightTyreDamage: UInt8
	public var rearLeftTyreDamage: UInt8
	public var rearRightTyreDamage: UInt8
	public var frontLeftWingDamage: UInt8
	public var frontRightWingDamage: UInt8
	public var rearWingDamage: UInt8
	public var engineDamage: UInt8
	public var gearBoxDamage: UInt8
	
	public init() {
		fuelMix = .standard
		tyreCompound = .unknown
		ersDeployMode = .none
		vehicleFlags = .none
		frontLeftTyreDamage = 0
		frontRightTyreDamage = 0
		rearLeftTyreDamage = 0
		rearRightTyreDamage = 0
		frontLeftWingDamage = 0
		frontRightWingDamage = 0
		rearWingDamage = 0
		engineDamage = 0
		gearBoxDamage = 0
	}
	
}

extension TKCarStatusInfo: CustomStringConvertible {
	
	public var description: String { "📊 Car status: fuel mix = \(fuelMix), tyre compound = \(tyreCompound.name), ERS = \(ersDeployMode), flags = \(vehicleFlags)\n🛠 Damages: FL tyre: \(frontLeftTyreDamage), FR tyre: \(frontRightTyreDamage), RL tyre: \(rearLeftTyreDamage), RR tyre: \(rearRightTyreDamage), FL wing: \(frontLeftWingDamage), FR wing: \(frontRightWingDamage), R wing: \(rearWingDamage), engine: \(engineDamage), gearbox: \(gearBoxDamage)" }
	
}

public struct TKRaceStatusInfo {
	
    public var currentLapTime: Float32
    public var lastLapTime: Float32
    public var bestLapTime: Float32
	public var currentLapNo: UInt8
	public var currentSector: TKSector
    public var currentLapDistance: Float32
	public var totalDistance: Float32
	public var currentPosition: UInt8
	public var gridPosition: UInt8
	public var pitStatus: TKPitStatus
	public var penalties: UInt8
	public var currentStatus: TKDriverStatus
	public var resultStatus: TKResultStatus
	public var safetyCarDelta: Float32
	public var lapTimes: [TKLapTime]
	
	public var lastLapTimeIsPersonnalBest: Bool { lastLapTime <= bestLapTime }
	
	public var latestS1Time: Float32 { (lapTimes.count > 0) ? lapTimes.last!.sector1Time : 0 }
	
	public var latestS1TimeIsPersonnalBest: Bool { (latestS1Time == 0) ? false : latestS1Time <= lapTimes.bestSector1Time ?? Float32.greatestFiniteMagnitude }

	public var latestS2Time: Float32 { (lapTimes.count > 0) ? ((currentSector == .sector2) ? 0 : lapTimes.last!.sector2Time) : 0 }
	
	public var latestS2TimeIsPersonnalBest: Bool { (latestS2Time == 0) ? false : latestS2Time <= lapTimes.bestSector2Time ?? Float32.greatestFiniteMagnitude }

	public var latestS3Time: Float32 { (lapTimes.count > 0) ? ((currentSector == .sector3) ? 0 : lapTimes.last!.sector3Time) : 0 }
	
	public var latestS3TimeIsPersonnalBest: Bool { (latestS3Time == 0) ? false : latestS3Time <= lapTimes.bestSector3Time ?? Float32.greatestFiniteMagnitude }

	public init() {
        currentLapTime = 0
        lastLapTime = 0
		bestLapTime = 0
		currentLapNo = 0
		currentSector = .sector1
        currentLapDistance = 0
		totalDistance = 0
		currentPosition = 0
		gridPosition = 0
		pitStatus = .none
		penalties = 0
		currentStatus = .inGarage
		resultStatus = .inactive
		safetyCarDelta = 0
		lapTimes = [TKLapTime]()
	}
	
	public mutating func set(lapTime: Float32, forLapNo lapNo: UInt8) {
		ensureIsAvailable(lapNo: lapNo)
		lapTimes[Int(lapNo) - 1].lapTime = lapTime
		if lapTime < bestLapTime {
			bestLapTime = lapTime
		}
	}
	
	public mutating func set(lapTimeInvalidated: Bool, forLapNo lapNo: UInt8) -> Bool {
		//TODO: uncomment this but make sure it doesn't mess up the `lapTimes` array
		/*
		ensureIsAvailable(lapNo: lapNo)
		if !lapTimes[Int(lapNo) - 1].invalidated {
			lapTimes[Int(lapNo) - 1].invalidated = true
			return true
		}
		*/
		return false
	}
	
	public mutating func set(sector1Time: Float, forLapNo lapNo: UInt8) {
		ensureIsAvailable(lapNo: lapNo)
		lapTimes[Int(lapNo) - 1].sector1Time = sector1Time
	}
	
	public mutating func set(sector2Time: Float, forLapNo lapNo: UInt8) {
		ensureIsAvailable(lapNo: lapNo)
		lapTimes[Int(lapNo) - 1].sector2Time = sector2Time
	}
	
	public mutating func set(sector3Time: Float, forLapNo lapNo: UInt8) {
		ensureIsAvailable(lapNo: lapNo)
		lapTimes[Int(lapNo) - 1].sector3Time = sector3Time
	}
	
	private mutating func ensureIsAvailable(lapNo: UInt8) {
		while lapNo > lapTimes.count {
			lapTimes.append(TKLapTime())
		}
	}

}

extension TKRaceStatusInfo: CustomStringConvertible {
	
	public var description: String { "" }
	
}

public struct TKLapTime {
	
	public var sector1Time: Float32
	public var sector2Time: Float32
	public var sector3Time: Float32
	public var lapTime: Float32
	public var lapDistance: Float32
	public var invalidated: Bool
	
	public var isCompleteLapTime: Bool { (sector1Time > 0) && (sector2Time > 0) && (sector3Time > 0) && (lapTime > 0) }
	
	public init() {
		sector1Time = 0
		sector2Time = 0
		sector3Time = 0
		lapTime = 0
		lapDistance = 0
		invalidated = false
	}
	
}

extension TKLapTime: CustomStringConvertible {
	
	public var description: String { !isCompleteLapTime ? "(incomplete)" : "\(lapTime.asLapTimeString) (S1: \(sector1Time.asSectorTimeString), S2: \(sector2Time.asSectorTimeString), S3: \(sector3Time.asSectorTimeString))" }
	
}

public extension Array where Element == TKLapTime {
	
	var bestSector1Time: Float32? { self.filter { $0.sector1Time > 0 }.map { $0.sector1Time }.min() }
	
	var bestSector2Time: Float32? { self.filter { $0.sector2Time > 0 }.map { $0.sector2Time }.min() }
	
	var bestSector3Time: Float32? { self.filter { $0.sector3Time > 0 }.map { $0.sector3Time }.min() }
	
	var bestLapTime: Float32? { self.filter { $0.lapTime > 0 }.map { $0.lapTime }.min() }
	
	var bestSector1TimeLapNo: UInt8? {
		guard let lapIndex = self.firstIndex(where: { $0.sector1Time == self.bestSector1Time }) else {
			return nil
		}
		return UInt8(lapIndex + 1)
	}
	
	var bestSector2TimeLapNo: UInt8? {
		guard let lapIndex = self.firstIndex(where: { $0.sector2Time == self.bestSector2Time }) else {
			return nil
		}
		return UInt8(lapIndex + 1)
	}
	
	var bestSector3TimeLapNo: UInt8? {
		guard let lapIndex = self.firstIndex(where: { $0.sector3Time == self.bestSector3Time }) else {
			return nil
		}
		return UInt8(lapIndex + 1)
	}

	var bestLapTimeLapNo: UInt8? {
		guard let lapIndex = self.firstIndex(where: { $0.lapTime == self.bestLapTime }) else {
			return nil
		}
		return UInt8(lapIndex + 1)
	}

}

public struct TKRaceLeaderReference {
	
	public var timestamp: Float32
	public var lapNo: UInt8
	public var lapDistance: Float32
	
}

extension TKRaceLeaderReference: CustomStringConvertible {
	
	public var description: String { "\(timestamp.asSessionTimeString): \(lapDistance) meters into lap no \(lapNo)" }
	
}

public struct TKSessionRanking {
	
	public var participant: TKParticipantInfo
	public var driverIndex: Int
	public var gapToLeader: Float32
	
}

extension TKSessionRanking: CustomStringConvertible {
	
	public var description: String { "\(participant.raceStatus.currentPosition) – \(participant.name) – lap \(participant.raceStatus.currentLapNo) – \(participant.raceStatus.currentPosition == 1 ? "LEADER" : "+\(gapToLeader.asGapString)")" }
	
}

public extension Array where Element == TKSessionRanking {
	
	func position(ofDriver driver: TKDriver) -> UInt8? {
		for (i, p) in self.enumerated() {
			if p.participant.driverId == driver {
				return UInt8(i + 1)
			}
		}
		return nil
	}
	
}
