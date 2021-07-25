//
//  TKParticipantsPacket.swift
//  TelemetryKit
//
//  Created by Romain on 08/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal struct TKParticipantData: TKPacket {
	
	static let PACKET_SIZE_F1_2020: Int = 54
    static let PACKET_SIZE_F1_2021: Int = 56
	
	var aiControlled: TKBool
	var driverId: TKDriver
    var networkId: UInt8 // New in F1 2021
	var teamId: TKTeam
    var isMyTeam: TKBool // New in F1 2021
	var raceNumber: UInt8
	var nationality: TKNationality
	var name: [UInt8] // 48
	var yourTelemetry: TKBool
	
	var nameAsString: String {
		return String(bytes: name, encoding: .utf8)!
	}
	
	init() {
		aiControlled = .no
        driverId = .unknownDriver
        networkId = 0
		teamId = .mercedes
        isMyTeam = .no
		raceNumber = 0
		nationality = .unknown
		name = [UInt8]()
		yourTelemetry = .no
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        case .f1_2020:
            let tmpAIControlled: TKBool = type(of: self).readEnum(fromRawData: data, at: offset + 0)
            aiControlled = tmpAIControlled.opposite
            let driverIdTmp: UInt8 = type(of: self).read(fromRawData: data, at: offset + 1)
            driverId = TKDriver(rawValue: driverIdTmp) ?? .unknownDriver
            let teamIdTmp: UInt8 = type(of: self).read(fromRawData: data, at: offset + 2)
            teamId = TKTeam(rawValue: teamIdTmp) ?? .unknownTeam
            raceNumber = type(of: self).read(fromRawData: data, at: offset + 3)
            nationality = type(of: self).readEnum(fromRawData: data, at: offset + 4)
            name = type(of: self).readArray(ofSize: 48, fromRawData: data, at: offset + 5)
            yourTelemetry = type(of: self).readEnum(fromRawData: data, at: offset + 53)
        case .f1_2021:
            let tmpAIControlled: TKBool = type(of: self).readEnum(fromRawData: data, at: offset + 0)
            aiControlled = tmpAIControlled.opposite
            let driverIdTmp: UInt8 = type(of: self).read(fromRawData: data, at: offset + 1)
            driverId = TKDriver(rawValue: driverIdTmp) ?? .unknownDriver
            networkId = type(of: self).read(fromRawData: data, at: offset + 2)
            let teamIdTmp: UInt8 = type(of: self).read(fromRawData: data, at: offset + 3)
            teamId = TKTeam(rawValue: teamIdTmp) ?? .unknownTeam
            let tmpMyTeam: TKBool = type(of: self).readEnum(fromRawData: data, at: offset + 4)
            isMyTeam = tmpMyTeam.opposite
            raceNumber = type(of: self).read(fromRawData: data, at: offset + 5)
            nationality = type(of: self).readEnum(fromRawData: data, at: offset + 6)
            name = type(of: self).readArray(ofSize: 48, fromRawData: data, at: offset + 7)
            yourTelemetry = type(of: self).readEnum(fromRawData: data, at: offset + 55)
        }
	}
	
}

extension TKParticipantData: CustomStringConvertible {
	
	var description: String {
        return "\(nameAsString)\(aiControlled.boolValue ? " (AI)" : "") – driver ID: \(driverId) – nationality: \(nationality) – team: \(teamId)\(isMyTeam.boolValue ? " (My Team)" : "") – race number: \(raceNumber)"
	}
	
}

internal struct TKParticipantsPacket: TKPacket {
	
    static let PACKET_SIZE_F1_2020: Int = TKPacketHeader.packetSize(forVersion: .f1_2020) + 1 + (Self.DRIVERS_COUNT * TKParticipantData.packetSize(forVersion: .f1_2020))
    static let PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + 1 + (Self.DRIVERS_COUNT * TKParticipantData.packetSize(forVersion: .f1_2021))
	
	var header: TKPacketHeader
	var numActiveCars: UInt8
	var participants: [TKParticipantData] // 22
	
	init() {
		header = TKPacketHeader()
		numActiveCars = 0
		participants = [TKParticipantData]()
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
		header = TKPacketHeader.build(fromRawData: data, forVersion: version)
        switch version {
        case .unknown:
            return
        default:
            numActiveCars = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0)
            participants = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 1, forVersion: version)
        }
	}
	
	func process(withDelegate delegate: TKDelegate) {
		delegate.update(participants: Array(participants.prefix(Int(numActiveCars))))
	}
	
}

extension TKParticipantsPacket: CustomStringConvertible {
	
	var description: String {
		var lines = [String]()
		lines.append(header.description)
		lines.append("\tActive cars: \(numActiveCars)")
		for (index, pd) in participants.enumerated() {
			lines.append("\t\tParticipant \(index + 1): \(pd.description)")
		}
		return lines.joined(separator: "\n")
	}
	
}
