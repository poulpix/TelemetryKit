//
//  TKLapDataPacket.swift
//  TelemetryKit
//
//  Created by Romain on 08/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal struct TKLapData: TKPacket {
	
	static let PACKET_SIZE_F1_2020: Int = 53
    static let PACKET_SIZE_F1_2021: Int = 43
	
	var lastLapTime: Float32 // sec
    var lastLapTimeInMS: UInt32 // ms – New in F1 2021
	var currentLapTime: Float32 // sec
    var currentLapTimeInMS: UInt32 // ms – New in F1 2021
	var sector1TimeInMS: UInt16 // ms
	var sector2TimeInMS: UInt16 // ms
	var bestLapTime: Float32 // sec – Moved elsewhere in F1 2021
    var bestLapNum: UInt8 // Moved elsewhere in F1 2021
	var bestLapSector1TimeInMS: UInt16 // ms – Moved elsewhere in F1 2021
	var bestLapSector2TimeInMS: UInt16 // ms – Moved elsewhere in F1 2021
	var bestLapSector3TimeInMS: UInt16 // ms – Moved elsewhere in F1 2021
	var bestOverallSector1TimeInMS: UInt16 // ms – Moved elsewhere in F1 2021
	var bestOverallSector1LapNum: UInt8 // Moved elsewhere in F1 2021
	var bestOverallSector2TimeInMS: UInt16 // ms – Moved elsewhere in F1 2021
	var bestOverallSector2LapNum: UInt8 // Moved elsewhere in F1 2021
	var bestOverallSector3TimeInMS: UInt16 // ms – Moved elsewhere in F1 2021
	var bestOverallSector3LapNum: UInt8 // Moved elsewhere in F1 2021
	var lapDistance: Float32 // meters
	var totalDistance: Float32 // meters
	var safetyCarDelta: Float32 // sec
	var carPosition: UInt8
	var currentLapNum: UInt8
	var pitStatus: TKPitStatus
    var numPitStops: UInt8 // New in F1 2021
	var sector: TKSector
	var currentLapInvalid: TKBool
	var penalties: UInt8 // sec
    var numWarnings: UInt8 // New in F1 2021
    var numUnservedDriveThroughPenalties: UInt8 // New in F1 2021
    var numUnservedStopGoPenalties: UInt8 // New in F1 2021
	var gridPosition: UInt8
	var driverStatus: TKDriverStatus
	var resultStatus: TKResultStatus
    var pitLaneTimerInactive: TKBool // New in F1 2021
    var pitLaneTimeInLaneInMS: UInt16 // ms – New in F1 2021
    var pitStopTimerInMs: UInt16 // ms – New in F1 2021
    var pitStopShouldServePenalty: TKBool // New in F1 2021
	
	var sector1Time: Float32 {
		return Float32(sector1TimeInMS) / 1000.0
	}
	var sector2Time: Float32 {
		return Float32(sector2TimeInMS) / 1000.0
	}
	
	init() {
		lastLapTime = 0
        lastLapTimeInMS = 0
		currentLapTime = 0
        currentLapTimeInMS = 0
		sector1TimeInMS = 0
		sector2TimeInMS = 0
		bestLapTime = 0
		bestLapNum = 0
		bestLapSector1TimeInMS = 0
		bestLapSector2TimeInMS = 0
		bestLapSector3TimeInMS = 0
		bestOverallSector1TimeInMS = 0
		bestOverallSector1LapNum = 0
		bestOverallSector2TimeInMS = 0
		bestOverallSector2LapNum = 0
		bestOverallSector3TimeInMS = 0
		bestOverallSector3LapNum = 0
		lapDistance = 0
		totalDistance = 0
		safetyCarDelta = 0
		carPosition = 0
		currentLapNum = 0
		pitStatus = .none
        numPitStops = 0
		sector = .sector1
		currentLapInvalid = .no
		penalties = 0
        numWarnings = 0
        numUnservedDriveThroughPenalties = 0
        numUnservedStopGoPenalties = 0
		gridPosition = 0
		driverStatus = .inGarage
		resultStatus = .invalid
        pitLaneTimerInactive = .yes
        pitLaneTimeInLaneInMS = 0
        pitStopTimerInMs = 0
        pitStopShouldServePenalty = .no
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        case .f1_2020:
            lastLapTime = type(of: self).read(fromRawData: data, at: offset + 0)
            currentLapTime = type(of: self).read(fromRawData: data, at: offset + 4)
            sector1TimeInMS = type(of: self).read(fromRawData: data, at: offset + 8)
            sector2TimeInMS = type(of: self).read(fromRawData: data, at: offset + 10)
            bestLapTime = type(of: self).read(fromRawData: data, at: offset + 12)
            bestLapNum = type(of: self).read(fromRawData: data, at: offset + 16)
            bestLapSector1TimeInMS = type(of: self).read(fromRawData: data, at: 17)
            bestLapSector2TimeInMS = type(of: self).read(fromRawData: data, at: 19)
            bestLapSector3TimeInMS = type(of: self).read(fromRawData: data, at: 21)
            bestOverallSector1TimeInMS = type(of: self).read(fromRawData: data, at: 23)
            bestOverallSector1LapNum = type(of: self).read(fromRawData: data, at: 25)
            bestOverallSector2TimeInMS = type(of: self).read(fromRawData: data, at: 26)
            bestOverallSector2LapNum = type(of: self).read(fromRawData: data, at: 28)
            bestOverallSector3TimeInMS = type(of: self).read(fromRawData: data, at: 29)
            bestOverallSector3LapNum = type(of: self).read(fromRawData: data, at: 31)
            lapDistance = type(of: self).read(fromRawData: data, at: offset + 32)
            totalDistance = type(of: self).read(fromRawData: data, at: offset + 36)
            safetyCarDelta = type(of: self).read(fromRawData: data, at: offset + 40)
            carPosition = type(of: self).read(fromRawData: data, at: offset + 44)
            currentLapNum = type(of: self).read(fromRawData: data, at: offset + 45)
            pitStatus = type(of: self).readEnum(fromRawData: data, at: offset + 46)
            sector = type(of: self).readEnum(fromRawData: data, at: offset + 47)
            currentLapInvalid = type(of: self).readEnum(fromRawData: data, at: offset + 48)
            penalties = type(of: self).read(fromRawData: data, at: offset + 49)
            gridPosition = type(of: self).read(fromRawData: data, at: offset + 50)
            driverStatus = type(of: self).readEnum(fromRawData: data, at: offset + 51)
            resultStatus = type(of: self).readEnum(fromRawData: data, at: offset + 52)
        case .f1_2021:
            lastLapTimeInMS = type(of: self).read(fromRawData: data, at: offset + 0)
            currentLapTimeInMS = type(of: self).read(fromRawData: data, at: offset + 4)
            sector1TimeInMS = type(of: self).read(fromRawData: data, at: offset + 8)
            sector2TimeInMS = type(of: self).read(fromRawData: data, at: offset + 10)
            lapDistance = type(of: self).read(fromRawData: data, at: offset + 12)
            totalDistance = type(of: self).read(fromRawData: data, at: offset + 16)
            safetyCarDelta = type(of: self).read(fromRawData: data, at: offset + 20)
            carPosition = type(of: self).read(fromRawData: data, at: offset + 24)
            currentLapNum = type(of: self).read(fromRawData: data, at: offset + 25)
            pitStatus = type(of: self).readEnum(fromRawData: data, at: offset + 26)
            numPitStops = type(of: self).read(fromRawData: data, at: offset + 27)
            sector = type(of: self).readEnum(fromRawData: data, at: offset + 28)
            currentLapInvalid = type(of: self).readEnum(fromRawData: data, at: offset + 29)
            penalties = type(of: self).read(fromRawData: data, at: offset + 30)
            numPitStops = type(of: self).read(fromRawData: data, at: offset + 31)
            numUnservedDriveThroughPenalties = type(of: self).read(fromRawData: data, at: offset + 32)
            numUnservedStopGoPenalties = type(of: self).read(fromRawData: data, at: offset + 33)
            gridPosition = type(of: self).read(fromRawData: data, at: offset + 34)
            driverStatus = type(of: self).readEnum(fromRawData: data, at: offset + 35)
            resultStatus = type(of: self).readEnum(fromRawData: data, at: offset + 36)
            pitLaneTimerInactive = type(of: self).readEnum(fromRawData: data, at: offset + 37)
            pitLaneTimeInLaneInMS = type(of: self).read(fromRawData: data, at: offset + 38)
            pitStopTimerInMs = type(of: self).read(fromRawData: data, at: offset + 40)
            pitStopShouldServePenalty = type(of: self).readEnum(fromRawData: data, at: offset + 42)
        }
	}
	
}

extension TKLapData: CustomStringConvertible {
	
	var description: String {
		return "last lap time: \(lastLapTime), current lap time: \(currentLapTime), best lap time: \(bestLapTime), position: \(carPosition), current lap number: \(currentLapNum), sector: \(sector), grid position: \(gridPosition), driver status: \(driverStatus), result status: \(resultStatus)"
	}
	
}

internal extension Array where Element == TKLapData {
	
	var leaderLapData: TKLapData {
		return (self.filter { $0.carPosition == 1 }).first!
	}
	
}

internal struct TKLapDataPacket: TKPacket {
	
    static let PACKET_SIZE_F1_2020: Int = TKPacketHeader.packetSize(forVersion: .f1_2020) + (Self.DRIVERS_COUNT * TKLapData.packetSize(forVersion: .f1_2020))
    static let PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + (Self.DRIVERS_COUNT * TKLapData.packetSize(forVersion: .f1_2021))
	
	var header: TKPacketHeader
	var lapData: [TKLapData] // 22
	
	init() {
		header = TKPacketHeader()
		lapData = [TKLapData]()
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
		header = TKPacketHeader.build(fromRawData: data, forVersion: version)
        switch version {
        case .unknown:
            return
        default:
            lapData = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0, forVersion: version)
        }
	}
	
	func process(withDelegate delegate: TKDelegate) {
		delegate.update(lapData: lapData, at: header.sessionTimestamp)
	}

}

extension TKLapDataPacket: CustomStringConvertible {
	
	var description: String {
		var lines = [String]()
		lines.append(header.description)
		for (index, ld) in lapData.enumerated() {
			lines.append("\t\tCar \(index + 1): \(ld.description)")
		}
		return lines.joined(separator: "\n")
	}
	
}
