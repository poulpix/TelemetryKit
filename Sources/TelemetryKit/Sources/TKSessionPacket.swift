//
//  TKSessionPacket.swift
//  TelemetryKit
//
//  Created by Romain on 08/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

public struct TKMarshalZone: TKPacket {
	
	static let PACKET_SIZE_F1_2020: Int = 5
    static let PACKET_SIZE_F1_2021: Int = 5
	
	var zoneStart: Float32 // 0...1
	var zoneFlag: TKZoneFlag
	
	init() {
		zoneStart = 0
		zoneFlag = .invalid
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        default:
            zoneStart = type(of: self).read(fromRawData: data, at: offset + 0)
            zoneFlag = type(of: self).readEnum(fromRawData: data, at: offset + 4)
        }
	}
	
}

extension TKMarshalZone: CustomStringConvertible {
	
	public var description: String {
		return "flag \(zoneFlag) at \(100 * zoneStart)"
	}
	
}

public struct TKWeatherForecastSample: TKPacket {
	
	static let PACKET_SIZE_F1_2020: Int = 5
    static let PACKET_SIZE_F1_2021: Int = 8
	
	var sessionType: TKSessionType
	var timeOffset: UInt8 // minutes
	var weather: TKWeather
	var trackTemperature: Int8 // °C
    var trackTemperatureChange: TKMetricChange // New in F1 2021
	var airTemperature: Int8 // °C
    var airTemperatureChange: TKMetricChange // New in F1 2021
    var rainPercentage: UInt8 // 0-100 – New in F1 2021
	
	init() {
		sessionType = .unknown
		timeOffset = 0
		weather = .clear
		trackTemperature = 0
        trackTemperatureChange = .noChange
		airTemperature = 0
        airTemperatureChange = .noChange
        rainPercentage = 0
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        case .f1_2020:
            sessionType = type(of: self).readEnum(fromRawData: data, at: offset + 0)
            timeOffset = type(of: self).read(fromRawData: data, at: offset + 1)
            weather = type(of: self).readEnum(fromRawData: data, at: offset + 2)
            trackTemperature = type(of: self).read(fromRawData: data, at: offset + 3)
            airTemperature = type(of: self).read(fromRawData: data, at: offset + 4)
        case .f1_2021:
            sessionType = type(of: self).readEnum(fromRawData: data, at: offset + 0)
            timeOffset = type(of: self).read(fromRawData: data, at: offset + 1)
            weather = type(of: self).readEnum(fromRawData: data, at: offset + 2)
            trackTemperature = type(of: self).read(fromRawData: data, at: offset + 3)
            trackTemperatureChange = type(of: self).readEnum(fromRawData: data, at: 4)
            airTemperature = type(of: self).read(fromRawData: data, at: offset + 5)
            airTemperatureChange = type(of: self).readEnum(fromRawData: data, at: offset + 6)
            rainPercentage = type(of: self).read(fromRawData: data, at: offset + 7)
        }
	}
	
}

extension TKWeatherForecastSample: CustomStringConvertible {
	
	public var description: String {
		return "Weather forecast in \(timeOffset) minutes: \(weather.emojiWeather) (\(sessionType.name), track temperature: \(trackTemperature), air temperature: \(airTemperature)"
	}
	
}

internal struct TKSessionPacket: TKPacket {
    
    static var NB_MARSHAL_ZONES_F1_2020 = 21
    static var NB_MARSHAL_ZONES_F1_2021 = 21
    static var NB_WEATHER_FORECASTS_F1_2020 = 20
    static var NB_WEATHER_FORECASTS_F1_2021 = 56
	
    static var PACKET_SIZE_F1_2020: Int = TKPacketHeader.packetSize(forVersion: .f1_2020) + (NB_MARSHAL_ZONES_F1_2020 * TKMarshalZone.packetSize(forVersion: .f1_2020)) + 22 + (NB_WEATHER_FORECASTS_F1_2020 * TKWeatherForecastSample.packetSize(forVersion: .f1_2020))
    static var PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + (NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: .f1_2021)) + 48 + (NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: .f1_2021))
	
	var header: TKPacketHeader
	var weather: TKWeather
	var trackTemperature: Int8 // °C
	var airTemperature: Int8 // °C
	var totalLaps: UInt8
	var trackLength: UInt16 // meters
	var sessionType: TKSessionType
	var trackId: TKTrack
	var formula: TKFormula
	var sessionTimeLeft: UInt16 // sec
	var sessionDuration: UInt16 // sec
	var pitSpeedLimit: UInt8 // km/h
	var gamePaused: TKBool
	var isSpectating: TKBool
	var spectatorCarIndex: UInt8
	var sliProNativeSupport: TKBool
	var numMarshalZones: UInt8
	var marshalZones: [TKMarshalZone] // 21
	var safetyCarStatus: TKSafetyCarStatus
	var networkGame: TKBool
	var numWeatherForecastSamples: UInt8
	var weatherForecastSamples: [TKWeatherForecastSample] // 20 for F1 2020, 56 for F1 2021
    var perfectForecastAccuracy: TKBool // New in F1 2021
    var aiDifficulty: UInt8 // 0-110 – New in F1 2021
    var seasonLinkIdentifier: UInt32 // New in F1 2021
    var weekendLinkIdentifier: UInt32 // New in F1 2021
    var sessionLinkIdentifier: UInt32 // New in F1 2021
    var pitStopWindowIdealLap: UInt8 // New in F1 2021
    var pitStopWindowLatestLap: UInt8 // New in F1 2021
    var pitStopRejoinPosition: UInt8 // New in F1 2021
    var steeringAssistDisabled: TKBool // New in F1 2021
    var brakingAssist: TKBrakingAssistType // New in F1 2021
    var gearboxAssist: TKGearboxAssistType // New in F1 2021
    var pitAssistDisabled: TKBool // New in F1 2021
    var pitReleaseAssistDisabled: TKBool // New in F1 2021
    var ersAssistDisabled: TKBool // New in F1 2021
    var drsAssistDisabled: TKBool // New in F1 2021
    var dynamicRacingLine: TKDynamicRacingLineType // New in F1 2021
    var dynamicRacingLineIn2D: TKBool // New in F1 2021
    
	var computedMarshalZones: [TKMarshalZone] {
		return Array(marshalZones.prefix(Int(numMarshalZones)))
	}
	
	init() {
		header = TKPacketHeader()
		weather = .clear
		trackTemperature = 0
		airTemperature = 0
		totalLaps = 0
		trackLength = 0
		sessionType = .unknown
		trackId = .melbourne
		formula = .f1modern
		sessionTimeLeft = 0
		sessionDuration = 0
		pitSpeedLimit = 0
		gamePaused = .no
		isSpectating = .no
		spectatorCarIndex = 0
		sliProNativeSupport = .no
		numMarshalZones = 0
		marshalZones = [TKMarshalZone]()
		safetyCarStatus = .noSafetyCar
		networkGame = .no
		numWeatherForecastSamples = 0
		weatherForecastSamples = [TKWeatherForecastSample]()
        perfectForecastAccuracy = .yes
        aiDifficulty = 0
        seasonLinkIdentifier = 0
        weekendLinkIdentifier = 0
        sessionLinkIdentifier = 0
        pitStopWindowIdealLap = 0
        pitStopWindowLatestLap = 0
        pitStopRejoinPosition = 0
        steeringAssistDisabled = .no
        brakingAssist = .off
        gearboxAssist = .manual
        pitAssistDisabled = .no
        pitReleaseAssistDisabled = .no
        ersAssistDisabled = .no
        drsAssistDisabled = .no
        dynamicRacingLine = .off
        dynamicRacingLineIn2D = .yes
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        header = TKPacketHeader.build(fromRawData: data, forVersion: version)
        switch version {
        case .unknown:
            return
        case .f1_2020:
            weather = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0)
            trackTemperature = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 1)
            airTemperature = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 2)
            totalLaps = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 3)
            trackLength = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4)
            sessionType = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 6)
            trackId = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 7)
            formula = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 8)
            sessionTimeLeft = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 9)
            sessionDuration = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 11)
            pitSpeedLimit = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 13)
            gamePaused = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 14)
            isSpectating = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 15)
            spectatorCarIndex = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 16)
            sliProNativeSupport = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 17)
            numMarshalZones = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 18)
            marshalZones = type(of: self).buildArray(ofSize: Self.NB_MARSHAL_ZONES_F1_2020, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 19, forVersion: version)
            safetyCarStatus = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 19 + Self.NB_MARSHAL_ZONES_F1_2020 * TKMarshalZone.packetSize(forVersion: version))
            let tmpNetworkGame: TKBool = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 20 + Self.NB_MARSHAL_ZONES_F1_2020 * TKMarshalZone.packetSize(forVersion: version))
            networkGame = tmpNetworkGame.opposite
            numWeatherForecastSamples = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 21 + Self.NB_MARSHAL_ZONES_F1_2020 * TKMarshalZone.packetSize(forVersion: version))
            weatherForecastSamples = type(of: self).buildArray(ofSize: Self.NB_WEATHER_FORECASTS_F1_2020, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 22 + Self.NB_MARSHAL_ZONES_F1_2020 * TKMarshalZone.packetSize(forVersion: version), forVersion: version)
        case .f1_2021:
            weather = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0)
            trackTemperature = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 1)
            airTemperature = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 2)
            totalLaps = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 3)
            trackLength = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 4)
            sessionType = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 6)
            trackId = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 7)
            formula = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 8)
            sessionTimeLeft = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 9)
            sessionDuration = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 11)
            pitSpeedLimit = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 13)
            gamePaused = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 14)
            isSpectating = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 15)
            spectatorCarIndex = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 16)
            sliProNativeSupport = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 17)
            numMarshalZones = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 18)
            marshalZones = type(of: self).buildArray(ofSize: Self.NB_MARSHAL_ZONES_F1_2021, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 19, forVersion: version)
            safetyCarStatus = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 19 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version))
            let tmpNetworkGame: TKBool = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 20 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version))
            networkGame = tmpNetworkGame.opposite
            numWeatherForecastSamples = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 21 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version))
            weatherForecastSamples = type(of: self).buildArray(ofSize: Self.NB_WEATHER_FORECASTS_F1_2021, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 22 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version), forVersion: version)
            perfectForecastAccuracy = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 22 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            aiDifficulty = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 23 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            seasonLinkIdentifier = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 24 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            weekendLinkIdentifier = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 28 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            sessionLinkIdentifier = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 32 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            pitStopWindowIdealLap = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 36 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            pitStopWindowLatestLap = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 37 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            pitStopRejoinPosition = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 38 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            steeringAssistDisabled = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 39 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            brakingAssist = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 40 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            gearboxAssist = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 41 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            pitAssistDisabled = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 42 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            pitReleaseAssistDisabled = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 43 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            ersAssistDisabled = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 44 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            drsAssistDisabled = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 45 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            dynamicRacingLine = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 46 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
            dynamicRacingLineIn2D = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 47 + Self.NB_MARSHAL_ZONES_F1_2021 * TKMarshalZone.packetSize(forVersion: version) + Self.NB_WEATHER_FORECASTS_F1_2021 * TKWeatherForecastSample.packetSize(forVersion: version))
        }
	}
	
	func process(withDelegate delegate: TKDelegate) {
		delegate.update(sessionInfo: self)
	}

}

extension TKSessionPacket: CustomStringConvertible {
	
	var description: String {
		var lines = [String]()
		lines.append(header.description)
		lines.append("\tWeather: \(weather), track temperature: \(trackTemperature), air temperature: \(airTemperature), total laps: \(totalLaps), session type: \(sessionType), track: \(trackId), formula: \(formula), session time left: \(sessionTimeLeft), session duration: \(sessionDuration), safety car status: \(safetyCarStatus)")
		for (index, mz) in marshalZones.enumerated() {
			if index < numMarshalZones {
				lines.append("\t\tMarshal zone \(index + 1): \(mz.description)")
			}
		}
		for (index, wfs) in weatherForecastSamples.enumerated() {
			if index < numWeatherForecastSamples {
				lines.append("\t\t\(wfs.description)")
			}
		}
		return lines.joined(separator: "\n")
	}
	
}
