//
//  TKSessionPacket.swift
//  TelemetryKit
//
//  Created by Romain on 08/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

public struct TKMarshalZone: TKPacket {
	
	static let PACKET_SIZE = 5
	
	var zoneStart: Float32 // 0...1
	var zoneFlag: TKZoneFlag
	
	init() {
		zoneStart = 0
		zoneFlag = .invalid
	}
	
	mutating func build(fromRawData data: Data, at offset: Int) {
		zoneStart = type(of: self).read(fromRawData: data, at: offset + 0)
		zoneFlag = type(of: self).readEnum(fromRawData: data, at: offset + 4)
	}
	
}

extension TKMarshalZone: CustomStringConvertible {
	
	public var description: String {
		return "flag \(zoneFlag) at \(100 * zoneStart)"
	}
	
}

public struct TKWeatherForecastSample: TKPacket {
	
	static let PACKET_SIZE = 5
	
	var sessionType: TKSessionType
	var timeOffset: UInt8 // minutes
	var weather: TKWeather
	var trackTemperature: Int8 // °C
	var airTemperature: Int8 // °C
	
	init() {
		sessionType = .unknown
		timeOffset = 0
		weather = .clear
		trackTemperature = 0
		airTemperature = 0
	}
	
	mutating func build(fromRawData data: Data, at offset: Int) {
		sessionType = type(of: self).readEnum(fromRawData: data, at: offset + 0)
		timeOffset = type(of: self).read(fromRawData: data, at: offset + 1)
		weather = type(of: self).readEnum(fromRawData: data, at: offset + 2)
		trackTemperature = type(of: self).read(fromRawData: data, at: offset + 3)
		airTemperature = type(of: self).read(fromRawData: data, at: offset + 4)
	}
	
}

extension TKWeatherForecastSample: CustomStringConvertible {
	
	public var description: String {
		return "Weather forecast in \(timeOffset) minutes: \(weather.emojiWeather) (\(sessionType.name), track temperature: \(trackTemperature), air temperature: \(airTemperature)"
	}
	
}

internal struct TKSessionPacket: TKPacket {
	
	static var PACKET_SIZE: Int = TKPacketHeader.PACKET_SIZE + (21 * TKMarshalZone.PACKET_SIZE) + 22 + (20 * TKWeatherForecastSample.PACKET_SIZE)
	
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
	var weatherForecastSamples: [TKWeatherForecastSample] // 20
	
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
	}
	
	mutating func build(fromRawData data: Data, at offset: Int) {
		header = TKPacketHeader.build(fromRawData: data)
		weather = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 0)
		trackTemperature = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 1)
		airTemperature = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 2)
		totalLaps = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 3)
		trackLength = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 4)
		sessionType = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 6)
		trackId = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 7)
		formula = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 8)
		sessionTimeLeft = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 9)
		sessionDuration = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 11)
		pitSpeedLimit = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 13)
		gamePaused = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 14)
		isSpectating = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 15)
		spectatorCarIndex = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 16)
		sliProNativeSupport = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 17)
		numMarshalZones = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 18)
		marshalZones = type(of: self).buildArray(ofSize: 21, fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 19)
		safetyCarStatus = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 19 + 21 * TKMarshalZone.PACKET_SIZE)
		let tmpNetworkGame: TKBool = type(of: self).readEnum(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 20 + 21 * TKMarshalZone.PACKET_SIZE)
		networkGame = tmpNetworkGame.opposite
		numWeatherForecastSamples = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 21 + 21 * TKMarshalZone.PACKET_SIZE)
		weatherForecastSamples = type(of: self).buildArray(ofSize: 20, fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 22 + 21 * TKMarshalZone.PACKET_SIZE)
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
