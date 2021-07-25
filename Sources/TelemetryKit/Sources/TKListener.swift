//
//  TKListener.swift
//  TelemetryKit
//
//  Created by Romain on 06/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation
import Combine
import CocoaAsyncSocket

public class TKListener: NSObject {
	
	public static let F1_2020_TELEMETRY_DEFAULT_PORT_NUMBER: UInt16 = 20777
	public static let DAMAGE_THRESHOLD_NOTIFICATION: UInt8 = 10
	public static let DEFAULT_PLAYER_FIRST_NAME: String = "Local"
	public static let DEFAULT_PLAYER_FAMILY_NAME: String = "PLAYER"
	public static let DEFAULT_PLAYER_TRIGRAM: String = "PLY"
	public static let DEFAULT_MY_TEAM_NAME: String = "My Team"
	
	public static let shared = TKListener()
	
    public var telemetryVersion: TKF1Version
	public var uiDelegate: TKUIDelegate?
	public var voiceDelegate: TKVoiceDelegate?
	public var acceptedPacketTypes: Set<TKPacketType>!
	internal var delegate: TKDelegate!
    private let liveSessionInfoQueue: DispatchQueue!
	private var socket: GCDAsyncUdpSocket!
	private var _liveSessionInfoUnsafe: TKLiveSessionInfo! // Do NOT access this directly!
	private var _raceEngineer: TKRaceEngineer!
	private var _portNumber: UInt16
	
    public var liveSessionInfo: TKLiveSessionInfo! {
        set {
			self.liveSessionInfoQueue.sync {
				self._liveSessionInfoUnsafe = newValue
			}
        }
        get {
            return liveSessionInfoQueue.sync {
                _liveSessionInfoUnsafe
            }
        }
    }
	
	private override init() {
        telemetryVersion = .unknown
        liveSessionInfoQueue = DispatchQueue(label: "TKSessionLiveInfo")
		_portNumber = TKListener.F1_2020_TELEMETRY_DEFAULT_PORT_NUMBER
		super.init()
		delegate = self
		setAcceptedPacketTypes(arrayLiteral: .carStatus, .event, .finalClassification, .lapData, .participants, .session)
		liveSessionInfo = TKLiveSessionInfo()
		_raceEngineer = TKRaceEngineer()
		_raceEngineer.delegate = self
		// Propagate changes from observable class members to subscribers of this observable object
		liveSessionInfo.objectWillChange.receive(subscriber: Subscribers.Sink(receiveCompletion: { _ in }) {
			DispatchQueue.main.async {
				self.objectWillChange.send()
			}
		})
	}
	
	@inlinable public func setAcceptedPacketTypes(arrayLiteral: TKPacketType...) {
		acceptedPacketTypes = Set(arrayLiteral)
	}
	
	public func listen(onPortNumber portNumber: UInt16 = TKListener.F1_2020_TELEMETRY_DEFAULT_PORT_NUMBER) {
		socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.global(qos: .userInteractive))
		_portNumber = portNumber
		do {
			try self.socket.bind(toPort: _portNumber)
			try self.socket.beginReceiving()
			print("🎤 Now listening on localhost:\(_portNumber)")
			try socket.enableBroadcast(true)
			// TODO: uncomment this to start working on race engineer voice synthesis again
			//_raceEngineer.fetchLUISntent(query: "Where's Kimi?")
		} catch {
			print("❌ \(error)")
		}
	}
	
	public func stop() {
		socket.close()
		print("🛑 Stopped listening on localhost:\(_portNumber)")
	}
	
}

extension TKListener: ObservableObject {
}

extension TKListener: GCDAsyncUdpSocketDelegate {
	
	public func udpSocket(_: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
		guard let _ = String(data: data, encoding: .utf16LittleEndian) else {
			return
		}
		let header = TKPacketHeader.build(fromRawData: data)
		if acceptedPacketTypes.contains(header.packetId) {
			header.processFullPacket(withRawData: data, andDelegate: delegate)
		} else {
			#if TRACE
			print("🗑 Dropping packet of type: \(header.packetId)")
			#endif
		}
	}

}

extension TKListener: TKDelegate {
	
	func update(sessionInfo: TKSessionPacket) {
		if sessionInfo.header.sessionUID != liveSessionInfo.sessionID {
            //liveSessionInfo = TKLiveSessionInfo()
			liveSessionInfo.sessionID = sessionInfo.header.sessionUID
			liveSessionInfo.weather = sessionInfo.weather
			liveSessionInfo.trackTemperature = sessionInfo.trackTemperature
			liveSessionInfo.airTemperature = sessionInfo.airTemperature
			liveSessionInfo.totalLaps = sessionInfo.totalLaps
			liveSessionInfo.trackLength = sessionInfo.trackLength
			liveSessionInfo.sessionType = sessionInfo.sessionType
			liveSessionInfo.trackId = sessionInfo.trackId
			liveSessionInfo.formula = sessionInfo.formula
			liveSessionInfo.duration = sessionInfo.sessionDuration
			liveSessionInfo.pitSpeedLimit = sessionInfo.pitSpeedLimit
			liveSessionInfo.isGamePaused = sessionInfo.gamePaused.opposite.boolValue
			liveSessionInfo.marshalZones = sessionInfo.computedMarshalZones
			liveSessionInfo.safetyCarStatus = sessionInfo.safetyCarStatus
			liveSessionInfo.isNetworkGame = sessionInfo.networkGame.boolValue
			print("🚥 A new session has been created: \(liveSessionInfo.sessionID)")
			print("\(liveSessionInfo.description)")
			uiDelegate?.sessionDidChange()
		}
		liveSessionInfo.timeLeft = sessionInfo.sessionTimeLeft
		uiDelegate?.sessionTimeLeftUpdated()
		if liveSessionInfo.weather != sessionInfo.weather {
			let oldWeather = liveSessionInfo.weather
			liveSessionInfo.weather = sessionInfo.weather
			print("☂️ Session conditions changed from \(oldWeather.emojiWeather) to \(sessionInfo.weather.emojiWeather)")
			uiDelegate?.weatherConditionsChanged(from: oldWeather, to: sessionInfo.weather)
		}
		if liveSessionInfo.trackTemperature != sessionInfo.trackTemperature {
			let oldTrackTemp = liveSessionInfo.trackTemperature
			liveSessionInfo.trackTemperature = sessionInfo.trackTemperature
			print("🌡 Track temperature changed from \(oldTrackTemp)°C to \(sessionInfo.trackTemperature)°C")
			uiDelegate?.trackTemperatureChanged(from: oldTrackTemp, to: sessionInfo.trackTemperature)
		}
		if liveSessionInfo.airTemperature != sessionInfo.airTemperature {
			let oldAirTemp = liveSessionInfo.airTemperature
			liveSessionInfo.airTemperature = sessionInfo.airTemperature
			print("🌡 Air temperature changed from \(oldAirTemp)°C to \(sessionInfo.airTemperature)°C")
			uiDelegate?.airTemperatureChanged(from: oldAirTemp, to: sessionInfo.airTemperature)
		}
		if liveSessionInfo.safetyCarStatus != sessionInfo.safetyCarStatus {
			let oldSafetyCar = liveSessionInfo.safetyCarStatus
			liveSessionInfo.safetyCarStatus = sessionInfo.safetyCarStatus
			print("🚨 Safety car status changed from \(oldSafetyCar.name) to \(sessionInfo.safetyCarStatus.name)")
			uiDelegate?.safetyCarStatusChanged(from: oldSafetyCar, to: sessionInfo.safetyCarStatus)
		}
		for (i, mz) in sessionInfo.computedMarshalZones.enumerated() {
			if (i < liveSessionInfo.marshalZones.count) && (liveSessionInfo.marshalZones[i].zoneFlag != mz.zoneFlag) {
				let oldFlag = liveSessionInfo.marshalZones[i].zoneFlag
				liveSessionInfo.marshalZones[i].zoneFlag = mz.zoneFlag
				if oldFlag != .none {
					print("🏴 Flag in zone no \(i + 1) changed from \(oldFlag.name) to \(mz.zoneFlag.name)")
					uiDelegate?.marshalZoneFlagChanged(no: UInt8(i + 1), from: oldFlag, to: mz.zoneFlag)
				}
			}
		}
	}
	
	func update(lapData: [TKLapData], at timestamp: Float32) {
		var positionsChanged = false
		for (i, ld) in lapData.enumerated() {
			if i < liveSessionInfo.participants.count {
				let driver = liveSessionInfo.driver(no: UInt8(i)) ?? TKParticipantInfo()
				if liveSessionInfo.participants[i].raceStatus.bestLapTime != ld.bestLapTime {
					let oldBestLapTime = liveSessionInfo.participants[i].raceStatus.bestLapTime
					liveSessionInfo.participants[i].raceStatus.bestLapTime = ld.bestLapTime
					if oldBestLapTime > 0 {
						print("⏱ \(driver.name) just set a new personal best lap time in \(ld.bestLapTime.asLapTimeString) (previous was: \(oldBestLapTime.asLapTimeString))")
					} else {
						print("⏱ \(driver.name) just set his first and personal best lap time in \(ld.bestLapTime.asLapTimeString)")
					}
					uiDelegate?.driver(driver, setBestLapTime: ld.bestLapTime, atLapNo: ld.currentLapNum - 1)
                    if (ld.bestLapTime < liveSessionInfo.bestLapTime) || (liveSessionInfo.bestLapTime == 0) {
                        liveSessionInfo.bestLapTime = ld.bestLapTime
                        print("⏱ \(driver.name) has set a new fastest lap time in \(ld.bestLapTime.asLapTimeString)")
                    }
				}
                if liveSessionInfo.participants[i].raceStatus.currentPosition != ld.carPosition {
					positionsChanged = true
					let oldPosition = liveSessionInfo.participants[i].raceStatus.currentPosition
					liveSessionInfo.participants[i].raceStatus.currentPosition = ld.carPosition
					if oldPosition > 0 {
						if oldPosition > ld.carPosition {
							print("📋 \(driver.name) progressed from P\(oldPosition) to P\(ld.carPosition)")
							uiDelegate?.driver(driver, positionChangedFrom: oldPosition, to:ld.carPosition)
						} else {
							if liveSessionInfo.sessionType.isRaceSession {
								print("📋 \(driver.name) dropped from P\(oldPosition) to P\(ld.carPosition)")
								uiDelegate?.driver(driver, positionChangedFrom: oldPosition, to:ld.carPosition)
							}
						}
					}
				}
                if (ld.currentLapNum > liveSessionInfo.participants[i].raceStatus.currentLapNo) {
                    let oldLapNo = liveSessionInfo.participants[i].raceStatus.currentLapNo
                    liveSessionInfo.participants[i].raceStatus.currentLapNo = ld.currentLapNum
                    liveSessionInfo.participants[i].raceStatus.lastLapTime = ld.lastLapTime
                    if (oldLapNo > 0) {
                        print("➰ \(driver.name) just finished lap no \(ld.currentLapNum) in \(ld.lastLapTime.asLapTimeString)")
                        liveSessionInfo.participants[i].raceStatus.set(lapTime: ld.lastLapTime, forLapNo: ld.currentLapNum - 1)
                        uiDelegate?.driver(driver, finishedLapNo: ld.currentLapNum, withTime: ld.lastLapTime)
                        uiDelegate?.driver(driver, setLapTime: ld.lastLapTime, forLapNo: ld.currentLapNum - 1)
                    }
				}
				if liveSessionInfo.participants[i].raceStatus.pitStatus != ld.pitStatus {
					let oldPitStatus = liveSessionInfo.participants[i].raceStatus.pitStatus
					liveSessionInfo.participants[i].raceStatus.pitStatus = ld.pitStatus
					print("🛑 \(driver.name) pit status changed from \(oldPitStatus.name) to \(ld.pitStatus.name)")
					uiDelegate?.driver(driver, pitStatusChangedFrom: oldPitStatus, to:ld.pitStatus)
				}
				if liveSessionInfo.participants[i].raceStatus.penalties > ld.penalties { // RLT: penalties can only increase
					let oldPenalties = liveSessionInfo.participants[i].raceStatus.penalties
					liveSessionInfo.participants[i].raceStatus.penalties = ld.penalties
					print("🔶 \(driver.name) received a time penalty of \(ld.penalties - oldPenalties) seconds")
					uiDelegate?.driver(driver, receivedTimePenalty: ld.penalties - oldPenalties)
				}
				if liveSessionInfo.participants[i].raceStatus.currentStatus != ld.driverStatus {
					let oldStatus = liveSessionInfo.participants[i].raceStatus.currentStatus
					liveSessionInfo.participants[i].raceStatus.currentStatus = ld.driverStatus
					print("〰️ \(driver.name) status changed from \(oldStatus.name) to \(ld.driverStatus.name)")
					uiDelegate?.driver(driver, statusChangedFrom: oldStatus, to:ld.driverStatus)
				}
				if liveSessionInfo.participants[i].raceStatus.resultStatus != ld.resultStatus {
					let oldResultStatus = liveSessionInfo.participants[i].raceStatus.resultStatus
					liveSessionInfo.participants[i].raceStatus.resultStatus = ld.resultStatus
					if oldResultStatus != .inactive {
						print("📢 \(driver.name) result status changed from \(oldResultStatus.name) to \(ld.resultStatus.name)")
						uiDelegate?.driver(driver, resultChangedFrom: oldResultStatus, to:ld.resultStatus)
					}
				}
				if liveSessionInfo.participants[i].raceStatus.currentSector != ld.sector {
					switch ld.sector {
					case .sector1:
						if ld.currentLapNum > 1 {
                            let s3Time = ld.lastLapTime - liveSessionInfo.participants[i].raceStatus.latestS1Time - liveSessionInfo.participants[i].raceStatus.latestS2Time
							liveSessionInfo.participants[i].raceStatus.set(sector3Time: s3Time, forLapNo: ld.currentLapNum - 1)
							uiDelegate?.driver(driver, setSector3Time: s3Time, forLapNo: ld.currentLapNum - 1)
                            if (s3Time < liveSessionInfo.bestS3Time) || (liveSessionInfo.bestS3Time == 0) {
                                liveSessionInfo.bestS3Time = s3Time
                                print("⏱ \(driver.name) just set the best sector 3 time in \(s3Time.asSectorTimeString)")
                            }
						}
					case .sector2:
						liveSessionInfo.participants[i].raceStatus.set(sector1Time: ld.sector1Time, forLapNo: ld.currentLapNum)
						uiDelegate?.driver(driver, setSector1Time: ld.sector1Time, forLapNo: ld.currentLapNum)
                        if (ld.sector1Time < liveSessionInfo.bestS1Time) || (liveSessionInfo.bestS1Time == 0) {
                            liveSessionInfo.bestS1Time = ld.sector1Time
                            print("⏱ \(driver.name) just set the best sector 1 time in \(ld.sector1Time.asSectorTimeString)")
                        }
					case .sector3:
						liveSessionInfo.participants[i].raceStatus.set(sector2Time: ld.sector2Time, forLapNo: ld.currentLapNum)
						uiDelegate?.driver(driver, setSector2Time: ld.sector2Time, forLapNo: ld.currentLapNum)
                        if (ld.sector2Time < liveSessionInfo.bestS2Time) || (liveSessionInfo.bestS2Time == 0) {
                            liveSessionInfo.bestS2Time = ld.sector2Time
                            print("⏱ \(driver.name) just set the best sector 2 time in \(ld.sector2Time.asSectorTimeString)")
                        }
					}
					liveSessionInfo.participants[i].raceStatus.currentSector = ld.sector
				}
				if ld.currentLapInvalid == .yes {
					let changesMade = liveSessionInfo.participants[i].raceStatus.set(lapTimeInvalidated: true, forLapNo: ld.currentLapNum)
					if changesMade {
						uiDelegate?.driver(driver, lapTimeInvalidatedForLapNo: ld.currentLapNum)
					}
				}
                liveSessionInfo.participants[i].raceStatus.currentLapTime = ld.currentLapTime
                liveSessionInfo.participants[i].raceStatus.currentLapDistance = ld.lapDistance
                liveSessionInfo.participants[i].raceStatus.totalDistance = ld.totalDistance
                liveSessionInfo.participants[i].raceStatus.safetyCarDelta = ld.safetyCarDelta
			}
		}
		let liveRankings = liveSessionInfo.liveRankings(at: timestamp)
		if positionsChanged {
			uiDelegate?.driversPositionsChanged(liveRankings)
		}
		if liveSessionInfo.sessionType.isRaceSession {
			let leaderLapData = lapData.leaderLapData
			liveSessionInfo.raceLeaderReference.append(TKRaceLeaderReference(timestamp: timestamp, lapNo: leaderLapData.currentLapNum, lapDistance: leaderLapData.lapDistance))
		}
		uiDelegate?.sessionRankingsUpdated(liveRankings)
	}
	
	func sessionStarted() {
		print("🏳️ Session started")
		liveSessionInfo = TKLiveSessionInfo()
		uiDelegate?.sessionStarted()
	}
	
	func sessionEnded() {
		print("🏁 Session ended")
		uiDelegate?.sessionEnded()
	}
	
	func driver(no driverNo: UInt8, setNewFastestLap lapTime: Float32) {
		print("⏱ \(liveSessionInfo.driverName(forNo: driverNo)) just set the new fastest lap, in \(lapTime.asLapTimeString)")
		uiDelegate?.driver(liveSessionInfo.driver(no: driverNo) ?? TKParticipantInfo(), setNewFastestLap: lapTime)
	}
	
	func driverRetired(no driverNo: UInt8) {
		print("⚠️ \(liveSessionInfo.driverName(forNo: driverNo)) has retired the car")
		uiDelegate?.driverRetired(liveSessionInfo.driver(no: driverNo) ?? TKParticipantInfo())
	}
	
	func drsEnabled() {
		print("✅ Race control: DRS enabled")
		uiDelegate?.drsEnabled()
	}
	
	func drsDisabled() {
		print("⛔️ Race control: DRS disabled")
		uiDelegate?.drsDisabled()
	}
	
	func driverTeamMateInPits(no driverNo: UInt8) {
		print("🔧 Team mate \(liveSessionInfo.driverName(forNo: driverNo)) is in the pits")
		uiDelegate?.driverTeamMateInPits(liveSessionInfo.driver(no: driverNo) ?? TKParticipantInfo())
	}
	
	func chequeredFlag() {
		print("🏁 Chequered flag")
		uiDelegate?.chequeredFlag()
	}
	
	func driverRaceWinner(no driverNo: UInt8) {
		print("🍾 \(liveSessionInfo.driverName(forNo: driverNo)) has won the race")
		uiDelegate?.driverRaceWinner(liveSessionInfo.driver(no: driverNo) ?? TKParticipantInfo())
	}
	
	func driver(no driverNo: UInt8, gotPenalty penalty: TKPenaltyType, forInfringement infringement: TKInfringementType, onLapNo lapNo: UInt8) {
		print("🚨 \(liveSessionInfo.driverName(forNo: driverNo)) got a penalty: \(penalty) for infringement: \(infringement) on lap \(lapNo)")
		uiDelegate?.driver(liveSessionInfo.driver(no: driverNo) ?? TKParticipantInfo(), gotPenalty: penalty, forInfringement: infringement, onLapNo: lapNo)
	}
	
	func driver(no driverNo: UInt8, triggeredSpeedTrap speedTrap: Float32) {
		print("💨 \(liveSessionInfo.driverName(forNo: driverNo)) triggered speed trap: \(speedTrap) kph")
		uiDelegate?.driver(liveSessionInfo.driver(no: driverNo) ?? TKParticipantInfo(), triggeredSpeedTrap: speedTrap)
	}
    
    func startLights(nbLights: UInt8) {
        print("🔴 Number of start lights on: \(nbLights)")
        uiDelegate?.startLights(nbLights)
    }
    
    func lightsOut() {
        print("🟢 It's lights out and away we go!")
        uiDelegate?.lightsOut()
    }
    
    func driverServedDriveThroughPenalty(no driverNo: UInt8) {
        print("⚖️ \(liveSessionInfo.driverName(forNo: driverNo)) just served a drive-through penalty")
        uiDelegate?.driverServedDriveThrougPenalty(liveSessionInfo.driver(no: driverNo) ?? TKParticipantInfo())
    }
    
    func driverServedStopGoPenalty(no driverNo: UInt8) {
        print("🚧 \(liveSessionInfo.driverName(forNo: driverNo)) just served a stop-go penalty")
        uiDelegate?.driverServedStopGoPenalty(liveSessionInfo.driver(no: driverNo) ?? TKParticipantInfo())
    }
    
    func flashbackUsed(frameID: UInt32, sessionTime: Float32) {
        print("📸 Using flashback to go back to session time: \(sessionTime) (frame ID: \(frameID))")
        uiDelegate?.flashbackUsed()
    }
    
    func buttonsPressed(buttons: UInt32) {
        print("🎮 Buttons pressed: \(buttons)")
        uiDelegate?.buttonsPressed(buttons)
    }
	
	func update(participants: [TKParticipantData]) {
		let delta = liveSessionInfo.participants.count - participants.count
		if delta < 0 {
			while liveSessionInfo.participants.count < participants.count {
				liveSessionInfo.participants.append(TKParticipantInfo())
			}
			print("🏎 Added \(abs(delta)) participants (now \(liveSessionInfo.participants.count) in total)")
		}
		if delta > 0 {
			liveSessionInfo.participants.removeLast(delta)
			print("🏎 Removed \(delta) participants (now \(liveSessionInfo.participants.count) in total)")
		}
		for (i, p) in participants.enumerated() {
			liveSessionInfo.participants[i].name = p.nameAsString
			liveSessionInfo.participants[i].isAI = p.aiControlled.boolValue
			liveSessionInfo.participants[i].driverId = p.driverId
			liveSessionInfo.participants[i].teamId = p.teamId
			liveSessionInfo.participants[i].raceNumber = p.raceNumber
			liveSessionInfo.participants[i].nationality = p.nationality
			if i >= participants.count + delta { // '+' sign because delta is negative in this situation
				print(liveSessionInfo.participants[i].description)
			}
		}
	}
	
	func update(carTelemetries: [TKCarTelemetryData]) {
		// TODO: only propagate delegate info if driver is among the requested ones
		/*
		for (i, ct) in carTelemetries.enumerated() {
			if i < _sessionLiveInfo.participants.count {
				uiDelegate?.driver(_sessionLiveInfo.driver(no: UInt8(i)) ?? TKParticipantInfo(), liveTelemetrySpeed: ct.speed, throttle: ct.throttle, steer: ct.steer, brake: ct.brake, clutch: ct.clutch, gear: ct.gear, engineRPM: ct.engineRPM, drs: ct.drs.boolValue)
			}
		}
		*/
	}
	
	func update(carStatuses: [TKCarStatusData]) {
		for (i, cs) in carStatuses.enumerated() {
			if i < liveSessionInfo.participants.count {
				let driver = liveSessionInfo.driver(no: UInt8(i)) ?? TKParticipantInfo()
				if liveSessionInfo.participants[i].carStatus.fuelMix != cs.fuelMix {
					let oldFuelMix = liveSessionInfo.participants[i].carStatus.fuelMix
					liveSessionInfo.participants[i].carStatus.fuelMix = cs.fuelMix
					print("⛽️ \(driver.name) changed fuel mix from \(oldFuelMix) to \(cs.fuelMix)")
					uiDelegate?.driver(driver, changedFuelMixFrom: oldFuelMix, to: cs.fuelMix)
				}
				if liveSessionInfo.participants[i].carStatus.tyreCompound != cs.tyreVisualCompound {
					let oldTyreCompound = liveSessionInfo.participants[i].carStatus.tyreCompound
					liveSessionInfo.participants[i].carStatus.tyreCompound = cs.tyreVisualCompound
					if oldTyreCompound != .unknown {
						print("🔧 \(driver.name) changed tyre compound from \(oldTyreCompound.name) to \(cs.tyreVisualCompound.name)")
					} else {
						print("🔧 \(driver.name) is racing with \(cs.tyreVisualCompound.name) tyre compound")
					}
					uiDelegate?.driver(driver, changedTyreCompoundFrom: oldTyreCompound, to: cs.tyreVisualCompound)
				}
				if liveSessionInfo.participants[i].carStatus.ersDeployMode != cs.ersDeployMode {
					let oldERSMode = liveSessionInfo.participants[i].carStatus.ersDeployMode
					liveSessionInfo.participants[i].carStatus.ersDeployMode = cs.ersDeployMode
					print("🔋 \(driver.name) changed ERS deploy mode from \(oldERSMode) to \(cs.ersDeployMode)")
					uiDelegate?.driver(driver, changedERSDeploymentFrom: oldERSMode, to: cs.ersDeployMode)
				}
				if liveSessionInfo.participants[i].carStatus.vehicleFlags != cs.vehicleFIAFlags {
					let oldFlags = liveSessionInfo.participants[i].carStatus.vehicleFlags
					liveSessionInfo.participants[i].carStatus.vehicleFlags = cs.vehicleFIAFlags
					if oldFlags != .none {
						print("🏴 Flag status for \(driver.name) changed from \(oldFlags) to \(cs.vehicleFIAFlags)")
						uiDelegate?.driver(driver, flagStatusChangedFrom: oldFlags, to: cs.vehicleFIAFlags)
					}
				}
				if liveSessionInfo.participants[i].carStatus.frontLeftTyreDamage != cs.tyresDamage[2] {
					let oldFLTyreDamage = liveSessionInfo.participants[i].carStatus.frontLeftTyreDamage
					liveSessionInfo.participants[i].carStatus.frontLeftTyreDamage = cs.tyresDamage[2]
					if TKListener.isSignificantDamageDiff(from: oldFLTyreDamage, to: cs.tyresDamage[2]) {
						print("🛠 \(driver.name)'s front left tyre damage level has changed from \(oldFLTyreDamage) to \(cs.tyresDamage[2])")
						uiDelegate?.driver(driver, frontLeftTyreDamageChangedFrom: oldFLTyreDamage, to: cs.tyresDamage[2])
					}
				}
				if liveSessionInfo.participants[i].carStatus.frontRightTyreDamage != cs.tyresDamage[3] {
					let oldFRTyreDamage = liveSessionInfo.participants[i].carStatus.frontRightTyreDamage
					liveSessionInfo.participants[i].carStatus.frontRightTyreDamage = cs.tyresDamage[3]
					if TKListener.isSignificantDamageDiff(from: oldFRTyreDamage, to: cs.tyresDamage[3]) {
						print("🛠 \(driver.name)'s front right tyre damage level has changed from \(oldFRTyreDamage) to \(cs.tyresDamage[3])")
						uiDelegate?.driver(driver, frontRightTyreDamageChangedFrom: oldFRTyreDamage, to: cs.tyresDamage[3])
					}
				}
				if liveSessionInfo.participants[i].carStatus.rearLeftTyreDamage != cs.tyresDamage[0] {
					let oldRLTyreDamage = liveSessionInfo.participants[i].carStatus.rearLeftTyreDamage
					liveSessionInfo.participants[i].carStatus.rearLeftTyreDamage = cs.tyresDamage[0]
					if TKListener.isSignificantDamageDiff(from: oldRLTyreDamage, to: cs.tyresDamage[0]) {
						print("🛠 \(driver.name)'s rear left tyre damage level has changed from \(oldRLTyreDamage) to \(cs.tyresDamage[0])")
						uiDelegate?.driver(driver, rearLeftTyreDamageChangedFrom: oldRLTyreDamage, to: cs.tyresDamage[0])
					}
				}
				if liveSessionInfo.participants[i].carStatus.rearRightTyreDamage != cs.tyresDamage[1] {
					let oldRRTyreDamage = liveSessionInfo.participants[i].carStatus.rearRightTyreDamage
					liveSessionInfo.participants[i].carStatus.rearRightTyreDamage = cs.tyresDamage[1]
					if TKListener.isSignificantDamageDiff(from: oldRRTyreDamage, to: cs.tyresDamage[1]) {
						print("🛠 \(driver.name)'s rear right tyre damage level has changed from \(oldRRTyreDamage) to \(cs.tyresDamage[1])")
						uiDelegate?.driver(driver, rearRightTyreDamageChangedFrom: oldRRTyreDamage, to: cs.tyresDamage[1])
					}
				}
				if liveSessionInfo.participants[i].carStatus.frontLeftWingDamage != cs.frontLeftWingDamage {
					let oldFLWingDamage = liveSessionInfo.participants[i].carStatus.frontLeftWingDamage
					liveSessionInfo.participants[i].carStatus.frontLeftWingDamage = cs.frontLeftWingDamage
					if TKListener.isSignificantDamageDiff(from: oldFLWingDamage, to: cs.frontLeftWingDamage) {
						print("🛠 \(driver.name)'s front left wing damage level has changed from \(oldFLWingDamage) to \(cs.frontLeftWingDamage)")
						uiDelegate?.driver(driver, frontLeftWingDamageChangedFrom: oldFLWingDamage, to: cs.frontLeftWingDamage)
					}
				}
				if liveSessionInfo.participants[i].carStatus.frontRightWingDamage != cs.frontRightWingDamage {
					let oldFRWingDamage = liveSessionInfo.participants[i].carStatus.frontRightWingDamage
					liveSessionInfo.participants[i].carStatus.frontRightWingDamage = cs.frontRightWingDamage
					if TKListener.isSignificantDamageDiff(from: oldFRWingDamage, to: cs.frontRightWingDamage) {
						print("🛠 \(driver.name)'s front right wing damage level has changed from \(oldFRWingDamage) to \(cs.frontRightWingDamage)")
						uiDelegate?.driver(driver, frontRightWingDamageChangedFrom: oldFRWingDamage, to: cs.frontRightWingDamage)
					}
				}
				if liveSessionInfo.participants[i].carStatus.rearWingDamage != cs.rearWingDamage {
					let oldRWingDamage = liveSessionInfo.participants[i].carStatus.rearWingDamage
					liveSessionInfo.participants[i].carStatus.rearWingDamage = cs.rearWingDamage
					if TKListener.isSignificantDamageDiff(from: oldRWingDamage, to: cs.rearWingDamage) {
						print("🛠 \(driver.name)'s rear wing damage level has changed from \(oldRWingDamage) to \(cs.rearWingDamage)")
						uiDelegate?.driver(driver, rearWingDamageChangedFrom: oldRWingDamage, to: cs.rearWingDamage)
					}
				}
				if liveSessionInfo.participants[i].carStatus.engineDamage != cs.engineDamage {
					let oldEngineDamage = liveSessionInfo.participants[i].carStatus.engineDamage
					liveSessionInfo.participants[i].carStatus.engineDamage = cs.engineDamage
					if TKListener.isSignificantDamageDiff(from: oldEngineDamage, to: cs.engineDamage) {
						print("🛠 \(driver.name)'s engine damage level has changed from \(oldEngineDamage) to \(cs.engineDamage)")
						uiDelegate?.driver(driver, engineDamageChangedFrom: oldEngineDamage, to: cs.engineDamage)
					}
				}
				if liveSessionInfo.participants[i].carStatus.gearBoxDamage != cs.gearBoxDamage {
					let oldGearBoxDamage = liveSessionInfo.participants[i].carStatus.gearBoxDamage
					liveSessionInfo.participants[i].carStatus.gearBoxDamage = cs.gearBoxDamage
					if TKListener.isSignificantDamageDiff(from: oldGearBoxDamage, to: cs.gearBoxDamage) {
						print("🛠 \(driver.name)'s gearbox damage level has changed from \(oldGearBoxDamage) to \(cs.gearBoxDamage)")
						uiDelegate?.driver(driver, gearboxDamageChangedFrom: oldGearBoxDamage, to: cs.gearBoxDamage)
					}
				}
			}
		}
	}
    
    func update(carDamages: [TKCarDamageData]) {
        for (i, cd) in carDamages.enumerated() {
            if i < liveSessionInfo.participants.count {
                let driver = liveSessionInfo.driver(no: UInt8(i)) ?? TKParticipantInfo()
                //TODO similar to func update(carStatuses: [TKCarStatusData])
            }
        }
    }
	
	func update(finalClassification: [TKFinalClassificationData]) {
		print("🏁 Final classification revealed")
		// TODO: propagate this to the UI
		for (i, fc) in finalClassification.enumerated() {
			print("\t\((liveSessionInfo.driver(no: UInt8(i)) ?? TKParticipantInfo()).name) – \(fc.description)")
		}
	}
	
	func update(players: [TKLobbyInfoData]) {
		print("🎮 Lobby info received")
		// TODO: propagate this to the UI
	}
	
	private static func isSignificantDamageDiff(from fromDamage: UInt8, to toDamage: UInt8) -> Bool {
		return Int(toDamage) - Int(fromDamage) > TKListener.DAMAGE_THRESHOLD_NOTIFICATION
	}

}

extension TKListener: TKInternalVoiceDelegate {
	
	func playerVoiceTranscription(_ transcription: String, didFailWithError error: Error) {
		print("⁉️ LUIS intent failed for voice transcripion \"\(transcription)\": \(error.localizedDescription)")
	}
	
	func playerVoiceTranscription(_ transcription: String, didReturnLUISResponse luisResponse: TKLUISResponse) {
		print("💭 LUIS intent found for voice transcription \"\(transcription)\": \(luisResponse.topScoringIntent.intent)")
	}
	
	func playerAskedFor(driverInfo driver: TKDriver) {
		print("💬 Player asked for info about \(driver.name)")
		_raceEngineer.makeRaceEngineerSpeak(utterances: ["\(driver.name) is currently in P5.", "He's 6 seconds ahead of you, and lapping 3 tenths a lap slower."])
	}
	
	func playerAskedFor(teamInfo team: TKTeam) {
		print("💬 Player asked for info about \(team.name)")
	}
	
	func playerAskedFor(positionInfo position: TKPosition) {
		print("💬 Player asked for info about position \(position)")
	}
	
	func raceEngineerWillSay(utterances: [String]) {
		voiceDelegate?.raceEngineerWillSay(utterances: utterances)
		print("🗯 Race engineer says: « \(utterances.joined(separator: " ")) »")
	}
		
}
