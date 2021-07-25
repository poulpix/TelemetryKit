//
//  TKFinalClassificationPacket.swift
//  TelemetryKit
//
//  Created by Romain on 12/07/2020.
//  Copyright © 2020 Poulpix. All rights reserved.
//

import Foundation

internal struct TKFinalClassificationData: TKPacket {
	
	static let PACKET_SIZE_F1_2020: Int = 37
    static let PACKET_SIZE_F1_2021: Int = 37
	
	var position: UInt8
	var numLaps: UInt8
	var gridPosition: UInt8
	var points: UInt8
	var numPitStops: UInt8
	var resultStatus: TKResultStatus
	var bestLapTime: Float32
    var bestLapTimeInMS: UInt32
	var totalRaceTime: Double
	var penaltiesTime: UInt8 // seconds
	var numPenalties: UInt8
	var numTyreStints: UInt8
	var tyreStintsActual: [TKTyreCompound] // 8
	var tyreStintsVisual: [TKTyreVisualCompound] // 8
	
	init() {
		position = 0
		numLaps = 0
		gridPosition = 0
		points = 0
		numPitStops = 0
		resultStatus = .invalid
		bestLapTime = 0
        bestLapTimeInMS = 0
		totalRaceTime = 0
		penaltiesTime = 0
		numPenalties = 0
		numTyreStints = 0
		tyreStintsActual = [TKTyreCompound]()
		tyreStintsVisual = [TKTyreVisualCompound]()
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        case .f1_2020:
            position = type(of: self).read(fromRawData: data, at: offset + 0)
            numLaps = type(of: self).read(fromRawData: data, at: offset + 1)
            gridPosition = type(of: self).read(fromRawData: data, at: offset + 2)
            points = type(of: self).read(fromRawData: data, at: offset + 3)
            numPitStops = type(of: self).read(fromRawData: data, at: offset + 4)
            resultStatus = type(of: self).readEnum(fromRawData: data, at: offset + 5)
            bestLapTime = type(of: self).read(fromRawData: data, at: offset + 6)
            totalRaceTime = type(of: self).read(fromRawData: data, at: offset + 10)
            penaltiesTime = type(of: self).read(fromRawData: data, at: offset + 18)
            numPenalties = type(of: self).read(fromRawData: data, at: offset + 19)
            numTyreStints = type(of: self).read(fromRawData: data, at: offset + 20)
            tyreStintsActual = type(of: self).readEnumArray(ofSize: 8, fromRawData: data, at: offset + 21)
            tyreStintsVisual = type(of: self).readEnumArray(ofSize: 8, fromRawData: data, at: offset + 29)
        case .f1_2021:
            position = type(of: self).read(fromRawData: data, at: offset + 0)
            numLaps = type(of: self).read(fromRawData: data, at: offset + 1)
            gridPosition = type(of: self).read(fromRawData: data, at: offset + 2)
            points = type(of: self).read(fromRawData: data, at: offset + 3)
            numPitStops = type(of: self).read(fromRawData: data, at: offset + 4)
            resultStatus = type(of: self).readEnum(fromRawData: data, at: offset + 5)
            bestLapTimeInMS = type(of: self).read(fromRawData: data, at: offset + 6)
            totalRaceTime = type(of: self).read(fromRawData: data, at: offset + 10)
            penaltiesTime = type(of: self).read(fromRawData: data, at: offset + 18)
            numPenalties = type(of: self).read(fromRawData: data, at: offset + 19)
            numTyreStints = type(of: self).read(fromRawData: data, at: offset + 20)
            tyreStintsActual = type(of: self).readEnumArray(ofSize: 8, fromRawData: data, at: offset + 21)
            tyreStintsVisual = type(of: self).readEnumArray(ofSize: 8, fromRawData: data, at: offset + 29)
        }
	}
	
}

extension TKFinalClassificationData: CustomStringConvertible {
	
	var description: String {
		return "\(position). \(numLaps) laps, \(numPitStops) pit stops, started \(gridPosition)., result: \(resultStatus) (\(points)), \(numPenalties) penalties (\(penaltiesTime) seconds)"
	}
	
}

internal struct TKFinalClassificationPacket: TKPacket {
	
    static let PACKET_SIZE_F1_2020: Int = TKPacketHeader.packetSize(forVersion: .f1_2020) + 1 + (Self.DRIVERS_COUNT * TKParticipantData.packetSize(forVersion: .f1_2020))
    static let PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + 1 + (Self.DRIVERS_COUNT * TKParticipantData.packetSize(forVersion: .f1_2021))
	
	var header: TKPacketHeader
	var numCars: UInt8
	var classificationData: [TKFinalClassificationData] // 22
	
	init() {
		header = TKPacketHeader()
		numCars = 0
		classificationData = [TKFinalClassificationData]()
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
		header = TKPacketHeader.build(fromRawData: data, forVersion: version)
        switch version {
        case .unknown:
            return
        default:
            numCars = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0)
            classificationData = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 1, forVersion: version)
        }
	}
	
	func process(withDelegate delegate: TKDelegate) {
		delegate.update(finalClassification: Array(classificationData.prefix(Int(numCars))))
	}
	
}

extension TKFinalClassificationPacket: CustomStringConvertible {
	
	var description: String {
		var lines = [String]()
		lines.append(header.description)
		lines.append("\tCars classified: \(numCars)")
		for (index, cd) in classificationData.enumerated() {
			lines.append("\t\tParticipant \(index + 1): \(cd.description)")
		}
		return lines.joined(separator: "\n")
	}
	
}
