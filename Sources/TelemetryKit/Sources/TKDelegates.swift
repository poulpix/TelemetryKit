//
//  TKDelegates.swift
//  TelemetryKit
//
//  Created by Romain on 14/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal protocol TKDelegate {
	
	// Session-related messages
	func update(sessionInfo: TKSessionPacket)
	
	// Lap-related messages
	func update(lapData: [TKLapData], at timestamp: Float32)
	
	// Event-related messages
	func sessionStarted()
	func sessionEnded()
	func driver(no driverNo: UInt8, setNewFastestLap lapTime: Float32)
	func driverRetired(no driverNo: UInt8)
	func drsEnabled()
	func drsDisabled()
	func driverTeamMateInPits(no driverNo: UInt8)
	func chequeredFlag()
	func driverRaceWinner(no driverNo: UInt8)
	func driver(no driverNo: UInt8, gotPenalty penalty: TKPenaltyType, forInfringement infringement: TKInfringementType, onLapNo lapNo: UInt8)
	func driver(no driverNo: UInt8, triggeredSpeedTrap speedTrap: Float32)
	
	// Participant-related messages
	func update(participants: [TKParticipantData])
	
	// Car telemetry-related messages
	func update(carTelemetries: [TKCarTelemetryData])
	
	// Car status-related messages
	func update(carStatuses: [TKCarStatusData])
	
	// Final classification-related messages
	func update(finalClassification: [TKFinalClassificationData])
	
	// Lobby-related messages
	func update(players: [TKLobbyInfoData])
	
}

public protocol TKUIDelegate {
		
	// Session-related messages
	func sessionDidChange()
	func sessionTimeLeftUpdated()
	func weatherConditionsChanged(from weatherFrom: TKWeather, to weatherTo: TKWeather)
	func trackTemperatureChanged(from trackTempFrom: Int8, to trackTempTo: Int8)
	func airTemperatureChanged(from airTempFrom: Int8, to airTempTo: Int8)
	func safetyCarStatusChanged(from safetyCarFrom: TKSafetyCarStatus, to safetyCarTo: TKSafetyCarStatus)
	func marshalZoneFlagChanged(no zoneNo: UInt8, from flagFrom: TKZoneFlag, to flagTo: TKZoneFlag)
	
	// Lap-related messages
	func driver(_ driver: TKParticipantInfo, setSector1Time s1: Float32, forLapNo lapNo: UInt8)
	func driver(_ driver: TKParticipantInfo, setSector2Time s2: Float32, forLapNo lapNo: UInt8)
	func driver(_ driver: TKParticipantInfo, setSector3Time s3: Float32, forLapNo lapNo: UInt8)
	func driver(_ driver: TKParticipantInfo, setLapTime lap: Float32, forLapNo lapNo: UInt8)
	func driver(_ driver: TKParticipantInfo, setBestLapTime lap: Float32, atLapNo lapNo: UInt8)
	func driver(_ driver: TKParticipantInfo, positionChangedFrom positionFrom: UInt8, to positionTo: UInt8)
    func driver(_ driver: TKParticipantInfo, finishedLapNo lapNo: UInt8, withTime lapTime: Float32)
	func driver(_ driver: TKParticipantInfo, pitStatusChangedFrom pitStatusFrom: TKPitStatus, to pitStatusTo: TKPitStatus)
	func driver(_ driver: TKParticipantInfo, lapTimeInvalidatedForLapNo lapNo: UInt8)
	func driver(_ driver: TKParticipantInfo, receivedTimePenalty timePenalty: UInt8)
	func driver(_ driver: TKParticipantInfo, statusChangedFrom statusFrom: TKDriverStatus, to statusTo: TKDriverStatus)
	func driver(_ driver: TKParticipantInfo, resultChangedFrom resultFrom: TKResultStatus, to resultTo: TKResultStatus)

	// Event-related messages
	func sessionStarted()
	func sessionEnded()
	func driver(_ driver: TKParticipantInfo, setNewFastestLap lapTime: Float32)
	func driverRetired(_ driver: TKParticipantInfo)
	func drsEnabled()
	func drsDisabled()
	func driverTeamMateInPits(_ driver: TKParticipantInfo)
	func chequeredFlag()
	func driverRaceWinner(_ driver: TKParticipantInfo)
	func driver(_ driver: TKParticipantInfo, gotPenalty penalty: TKPenaltyType, forInfringement infringement: TKInfringementType, onLapNo lapNo: UInt8)
	func driver(_ driver: TKParticipantInfo, triggeredSpeedTrap speedTrap: Float32)

	// Car telemetry-related messages
	func driver(_ driver: TKParticipantInfo, liveTelemetrySpeed speed: UInt16, throttle: Float32, steer: Float32, brake: Float32, clutch: UInt8, gear: Int8, engineRPM: UInt16, drs: Bool)
	
	// Car status-related messages
	func driver(_ driver: TKParticipantInfo, changedFuelMixFrom fuelMixFrom: TKFuelMix, to fuelMixTo: TKFuelMix)
	func driver(_ driver: TKParticipantInfo, changedTyreCompoundFrom tyreCompoundFrom: TKTyreVisualCompound, to tyreCompoundTo: TKTyreVisualCompound)
	func driver(_ driver: TKParticipantInfo, changedERSDeploymentFrom ersDeploymentFrom: TKERSDeploymentMode, to ersDeploymentTo: TKERSDeploymentMode)
	func driver(_ driver: TKParticipantInfo, flagStatusChangedFrom flagStatusFrom: TKVehicleFIAFlags, to flagStatusTo: TKVehicleFIAFlags)
	func driver(_ driver: TKParticipantInfo, frontLeftTyreDamageChangedFrom flTyreDamageFrom: UInt8, to flTyreDamageTo: UInt8)
	func driver(_ driver: TKParticipantInfo, frontRightTyreDamageChangedFrom frTyreDamageFrom: UInt8, to frTyreDamageTo: UInt8)
	func driver(_ driver: TKParticipantInfo, rearLeftTyreDamageChangedFrom rlTyreDamageFrom: UInt8, to rlTyreDamageTo: UInt8)
	func driver(_ driver: TKParticipantInfo, rearRightTyreDamageChangedFrom rrTyreDamageFrom: UInt8, to rrTyreDamageTo: UInt8)
	func driver(_ driver: TKParticipantInfo, frontLeftWingDamageChangedFrom flWingDamageFrom: UInt8, to flWingDamageTo: UInt8)
	func driver(_ driver: TKParticipantInfo, frontRightWingDamageChangedFrom frWingDamageFrom: UInt8, to frWingDamageTo: UInt8)
	func driver(_ driver: TKParticipantInfo, rearWingDamageChangedFrom rWingDamageFrom: UInt8, to rWingDamageTo: UInt8)
	func driver(_ driver: TKParticipantInfo, engineDamageChangedFrom engDamageFrom: UInt8, to engDamageTo: UInt8)
	func driver(_ driver: TKParticipantInfo, gearboxDamageChangedFrom gbxDamageFrom: UInt8, to gbxDamageTo: UInt8)

	// Enriched messages
	func driversPositionsChanged(_ rankings: [TKSessionRanking])
	func sessionRankingsUpdated(_ rankings: [TKSessionRanking])

}

internal protocol TKInternalVoiceDelegate {
	
	func playerVoiceTranscription(_ transcription: String, didFailWithError error: Error)
	func playerVoiceTranscription(_ transcription: String, didReturnLUISResponse luisResponse: TKLUISResponse)
	func playerAskedFor(driverInfo driver: TKDriver)
	func playerAskedFor(teamInfo team: TKTeam)
	func playerAskedFor(positionInfo position: TKPosition)
	func raceEngineerWillSay(utterances: [String])
	
}

public protocol TKVoiceDelegate {
	
	func raceEngineerWillSay(utterances: [String])
	
}
