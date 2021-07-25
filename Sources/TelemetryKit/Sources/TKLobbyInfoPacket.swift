//
//  TKLobbyInfoPacket.swift
//  TelemetryKit
//
//  Created by 8505305X on 12/07/2020.
//  Copyright © 2020 Poulpix. All rights reserved.
//

import Foundation

internal struct TKLobbyInfoData: TKPacket {
	
	static let PACKET_SIZE_F1_2020: Int = 52
    static let PACKET_SIZE_F1_2021: Int = 53
	
	var aiControlled: TKBool
	var teamId: TKTeam
	var nationality: TKNationality
	var name: [UInt8] // 48
    var carNumber: UInt8 // New in F1 2021
	var readyStatus: TKReadyStatus
	
	var nameAsString: String {
		return String(bytes: name, encoding: .utf8)!
	}
	
	init() {
		aiControlled = .no
		teamId = .myTeam
		nationality = .unknown
		name = [UInt8]()
        carNumber = 0
		readyStatus = .spectating
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
        switch version {
        case .unknown:
            return
        case .f1_2020:
            let tmpAIControlled: TKBool = type(of: self).readEnum(fromRawData: data, at: offset + 0)
            aiControlled = tmpAIControlled.opposite
            let teamIdTmp: UInt8 = type(of: self).read(fromRawData: data, at: offset + 1)
            teamId = TKTeam(rawValue: teamIdTmp) ?? .unknownTeam
            nationality = type(of: self).readEnum(fromRawData: data, at: offset + 2)
            name = type(of: self).readArray(ofSize: 48, fromRawData: data, at: offset + 3)
            readyStatus = type(of: self).readEnum(fromRawData: data, at: offset + 51)
        case .f1_2021:
            let tmpAIControlled: TKBool = type(of: self).readEnum(fromRawData: data, at: offset + 0)
            aiControlled = tmpAIControlled.opposite
            let teamIdTmp: UInt8 = type(of: self).read(fromRawData: data, at: offset + 1)
            teamId = TKTeam(rawValue: teamIdTmp) ?? .unknownTeam
            nationality = type(of: self).readEnum(fromRawData: data, at: offset + 2)
            name = type(of: self).readArray(ofSize: 48, fromRawData: data, at: offset + 3)
            carNumber = type(of: self).read(fromRawData: data, at: offset + 51)
            readyStatus = type(of: self).readEnum(fromRawData: data, at: offset + 52)
        }
	}
	
}

extension TKLobbyInfoData: CustomStringConvertible {
	
	var description: String {
		return "\(nameAsString)\(aiControlled.boolValue ? " (AI)" : "") – nationality: \(nationality) – team: \(teamId) – status: \(readyStatus)"
	}
	
}

internal struct TKLobbyInfoPacket: TKPacket {
	
    static let PACKET_SIZE_F1_2020: Int = TKPacketHeader.packetSize(forVersion: .f1_2020) + 1 + (Self.DRIVERS_COUNT * TKParticipantData.packetSize(forVersion: .f1_2020))
    static let PACKET_SIZE_F1_2021: Int = TKPacketHeader.packetSize(forVersion: .f1_2021) + 1 + (Self.DRIVERS_COUNT * TKParticipantData.packetSize(forVersion: .f1_2021))
	
	var header: TKPacketHeader
	var numPlayers: UInt8
	var lobbyPlayers: [TKLobbyInfoData] // 22
	
	init() {
		header = TKPacketHeader()
		numPlayers = 0
		lobbyPlayers = [TKLobbyInfoData]()
	}
	
	mutating func build(fromRawData data: Data, at offset: Int, forVersion version: TKF1Version) {
		header = TKPacketHeader.build(fromRawData: data, forVersion: version)
        switch version {
        case .unknown:
            return
        default:
            numPlayers = type(of: self).read(fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 0)
            lobbyPlayers = type(of: self).buildArray(ofSize: Self.DRIVERS_COUNT, fromRawData: data, at: TKPacketHeader.packetSize(forVersion: version) + 1, forVersion: version)
        }
	}
	
	func process(withDelegate delegate: TKDelegate) {
		delegate.update(players: Array(lobbyPlayers.prefix(Int(numPlayers))))
	}
	
}

extension TKLobbyInfoPacket: CustomStringConvertible {
	
	var description: String {
		var lines = [String]()
		lines.append(header.description)
		lines.append("\tPlayers: \(numPlayers)")
		for (index, lp) in lobbyPlayers.enumerated() {
			lines.append("\t\tPlayer \(index + 1): \(lp.description)")
		}
		return lines.joined(separator: "\n")
	}
	
}
