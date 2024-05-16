//
//  CovertIntToUUID.swift
//  SportsHub
//
//  Created by Anas Salah on 14/05/2024.
//

import Foundation

extension Int {
    func toUUID() -> UUID {
        var bytes: [UInt8] = []
        var value = self
        for _ in 0..<MemoryLayout.size(ofValue: self) {
            bytes.append(UInt8(value & 0xFF))
            value >>= 8
        }
        while bytes.count < 16 {
            bytes.append(0)
        }
        
        let uuidBytes = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)(bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], bytes[6], bytes[7], bytes[8], bytes[9], bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15])
        
        return UUID(uuid: uuidBytes)
    }
}

extension UUID {
    func toInt() -> Int? {
        let uuidBytes = withUnsafeBytes(of: self.uuid) { Data($0) }
        guard uuidBytes.count >= MemoryLayout<Int>.size else { return nil }
        
        var value: Int = 0
        for byte in uuidBytes.prefix(MemoryLayout<Int>.size).reversed() {
            value <<= 8
            value |= Int(byte)
        }
        return value
    }
}
