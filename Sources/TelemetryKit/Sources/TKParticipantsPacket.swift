//
//  TKParticipantsPacket.swift
//  TelemetryKit
//
//  Created by Romain on 08/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal struct TKParticipantData: TKPacket {
	
	static let PACKET_SIZE = 54
	
	var aiControlled: TKBool
	var driverId: TKDriver
	var teamId: TKTeam
	var raceNumber: UInt8
	var nationality: TKNationality
	var name: [UInt8] // 48
	var yourTelemetry: TKBool
	
	var nameAsString: String {
		return String(bytes: name, encoding: .utf8)!
	}
	
	init() {
		aiControlled = .no
		driverId = .localPlayer
		teamId = .mercedes
		raceNumber = 0
		nationality = .unknown
		name = [UInt8]()
		yourTelemetry = .no
	}
	
	mutating func build(fromRawData data: Data, at offset: Int) {
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
	}
	
}

extension TKParticipantData: CustomStringConvertible {
	
	var description: String {
		return "\(nameAsString)\(aiControlled.boolValue ? " (AI)" : "") – driver ID: \(driverId) – nationality: \(nationality) – team: \(teamId) – race number: \(raceNumber)"
	}
	
}

internal struct TKParticipantsPacket: TKPacket {
	
	static let PACKET_SIZE = TKPacketHeader.PACKET_SIZE + 1 + (Self.DRIVERS_COUNT * TKParticipantData.PACKET_SIZE)
	
	var header: TKPacketHeader
	var numActiveCars: UInt8
	var participants: [TKParticipantData] // 22
	
	init() {
		header = TKPacketHeader()
		numActiveCars = 0
		participants = [TKParticipantData]()
	}
	
	mutating func build(fromRawData data: Data, at offset: Int) {
		header = TKPacketHeader.build(fromRawData: data)
		numActiveCars = type(of: self).read(fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 0)
		participants = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.PACKET_SIZE + 1)
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
