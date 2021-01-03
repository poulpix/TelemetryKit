//
//  TKPacket.swift
//  TelemetryKit
//
//  Created by Romain on 07/07/2019.
//  Copyright © 2019 Poulpix. All rights reserved.
//

import Foundation

internal protocol TKPacket: CustomStringConvertible {
	
	static var PACKET_SIZE: Int { get }
	static var DRIVERS_COUNT: Int { get }
	
	var isValidPacket: Bool { get }
	
	init()
	
	mutating func build(fromRawData data: Data, at offset: Int)
	func process(withDelegate delegate: TKDelegate)
	static func build(fromRawData data: Data, at offset: Int) -> Self
	static func build<T: TKPacket>(fromRawData data: Data, at offset: Int) -> T
	static func buildArray(ofSize size: Int, fromRawData data: Data, at offset: Int) -> [Self]
	static func read<T: Numeric>(fromRawData data: Data, at position: Int) -> T
	static func readEnum<E: RawRepresentable>(fromRawData data: Data, at position: Int) -> E where E.RawValue == UInt8
	static func readEnum<E: RawRepresentable>(fromRawData data: Data, at position: Int) -> E where E.RawValue == Int8
	static func readArray<T: Numeric>(ofSize size: Int, fromRawData data: Data, at position: Int) -> [T]
	static func readEnumArray<E: RawRepresentable>(ofSize size: Int, fromRawData data: Data, at position: Int) -> [E] where E.RawValue == UInt8
	static func readEnumArray<E: RawRepresentable>(ofSize size: Int, fromRawData data: Data, at position: Int) -> [E] where E.RawValue == Int8
	
}

internal extension TKPacket {
	
	static var DRIVERS_COUNT: Int {
		return 22
	}
	
	var isValidPacket: Bool {
		return true
	}
	
	func process(withDelegate delegate: TKDelegate) {
	}
	
	static func build(fromRawData data: Data, at offset: Int = 0) -> Self {
		var packet = Self()
		packet.build(fromRawData: data, at: offset)
		return packet
	}
	
	static func build<T: TKPacket>(fromRawData data: Data, at offset: Int = 0) -> T {
		var packet = T()
		packet.build(fromRawData: data, at: offset)
		return packet
	}

	static func buildArray<T: TKPacket>(ofSize size: Int, fromRawData data: Data, at offset: Int) -> [T] {
		var o = offset
		var result = [T]()
		while result.count < size {
			let packet = T.build(fromRawData: data, at: o)
			result.append(packet)
			o += T.PACKET_SIZE
		}
		return result
	}
	
	static func read<T: Numeric>(fromRawData data: Data, at position: Int) -> T {
		var value: T = 0
		(data as NSData).getBytes(&value, range: NSMakeRange(position, MemoryLayout<T>.size))
		return value
	}
	
	static func readEnum<E: RawRepresentable>(fromRawData data: Data, at position: Int) -> E where E.RawValue == UInt8 {
		return E(rawValue: read(fromRawData: data, at: position))!
	}
	
	static func readEnum<E: RawRepresentable>(fromRawData data: Data, at position: Int) -> E where E.RawValue == Int8 {
		return E(rawValue: read(fromRawData: data, at: position))!
	}
	
	static func readArray<T: Numeric>(ofSize size: Int, fromRawData data: Data, at position: Int) -> [T] {
		var result = [T]()
		var p = position
		while result.count < size {
			result.append(read(fromRawData: data, at: p))
			p += MemoryLayout<T>.size
		}
		return result
	}
	
	static func readEnumArray<E: RawRepresentable>(ofSize size: Int, fromRawData data: Data, at position: Int) -> [E] where E.RawValue == UInt8 {
		let rawValues: [UInt8] = readArray(ofSize: size, fromRawData: data, at: position)
		return rawValues.map { E(rawValue: $0)! }
	}
	
	static func readEnumArray<E: RawRepresentable>(ofSize size: Int, fromRawData data: Data, at position: Int) -> [E] where E.RawValue == Int8 {
		let rawValues: [Int8] = readArray(ofSize: size, fromRawData: data, at: position)
		return rawValues.map { E(rawValue: $0)! }
	}
	
}
