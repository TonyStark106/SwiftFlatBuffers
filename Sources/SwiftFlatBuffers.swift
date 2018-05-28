//  SwiftFlatBuffers, licensed under the Apache License, Version 2.0, is from FlatBuffers.
//
//  SwiftFlatBuffers  <https://github.com/TonyStark106/SwiftFlatBuffers>
//
//  Created by TonyStark106 on 2017/5/12.
//

import Foundation

public typealias FBOffset = Int32

open class FBTable {
    open var hardSize: UInt {
        return 0
    }
    
    open var hardPos: FBOffset {
        return 0
    }
    
    public final var isFixed: Bool {
        return hardPos == 0
    }
    
    public final var bbData: Data {
        return _bb._data
    }
    
    fileprivate final var _bbPos: FBOffset!
    fileprivate final var _bb: FBBufferData!
    fileprivate private(set) final lazy var vTable: FBOffset = {
        return self.isFixed ? self._bbPos : self._bbPos - self._bb.dataGetInt32(offset: self._bbPos)
    }()
    
    required public init() {
        let bufferData = FBBufferData(capacity: hardSize)
        if isFixed {
            _bbPos = 0
            _bb = bufferData
        } else {
            let vTable: FBOffset = 6
            bufferData.dataSet(offset: 0, value: hardPos, length: 4)
            // pos
            bufferData.dataSet(offset: hardPos, value: hardPos - vTable, length: 4)
            // vTable(vTable maxOffset)
            bufferData.dataSet(offset: vTable, value: hardPos - vTable, length: 2)
            // payloadSize
            bufferData.dataSet(offset: vTable + 2, value: FBOffset(hardSize) - hardPos, length: 2)
            _bbPos = hardPos
            _bb = bufferData
        }
        if FBTable.verifier(_bbPos, vTable, _bb, isFixed) == false {
            fatalError("something must wrong")
        }
    }
    
    required public init?(root: Data) {
        let bb = FBBufferData(data: root)
        let bbPos = bb.dataGetInt32(offset: 0)
        _bbPos = bbPos
        _bb = bb
        if FBTable.verifier(_bbPos, vTable, bb, isFixed) == false {
            return nil
        }
    }
    
    required public init?(pos: FBOffset, bb: FBBufferData) {
        _bbPos = pos
        _bb = bb
        if FBTable.verifier(_bbPos, vTable, bb, isFixed) == false {
            return nil
        }
    }
    
    open func toFBData() -> Data {
        fatalError("something must wrong")
    }
    
}

// MARK: - Deserialize
extension FBTable {
    fileprivate static func verifier(_ bbPos: FBOffset, _ vTable: FBOffset, _ bb: FBBufferData, _ isFixed: Bool) -> Bool {
        if bbPos >= bb.length {
            return false
        }
        if isFixed {
            return true
        }
        if (vTable < 0) {
            return false
        }
        let vMaxOffset = bb.dataGetInt16(offset: FBOffset(vTable))
        if vMaxOffset <= 0 {
            return false
        }
        let sizeOffset = vTable + 2
        let payloadSize = bb.dataGetInt16(offset: FBOffset(sizeOffset))
        if Int32(payloadSize) > bb.length - bbPos || payloadSize < 0 {
            return false
        }
        for i in 0..<(vMaxOffset - 4) / 2 {
            let itemOffset = vTable + 4 + Int32(i) * 2
            let vItem = bb.dataGetInt16(offset: FBOffset(itemOffset))
            if Int32(vItem) >= bb.length || vItem < 0 {
                return false
            }
        }
        return true
    }
    
    public final func getBool(vOffset: FBOffset) -> Bool {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return false
        }
        return _bb.dataGetBool(offset: offset)
    }
    
    public final func getInt8(vOffset: FBOffset) -> Int8 {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return 0
        }
        return _bb.dataGetInt8(offset: offset)
    }
    
    public final func getUInt8(vOffset: FBOffset) -> UInt8 {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return 0
        }
        return _bb.dataGetUInt8(offset: offset)
    }
    
    public final func getInt16(vOffset: FBOffset) -> Int16 {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return 0
        }
        return _bb.dataGetInt16(offset: offset)
    }
    
    public final func getUInt16(vOffset: FBOffset) -> UInt16 {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return 0
        }
        return _bb.dataGetUInt16(offset: offset)
    }
    
    public final func getInt32(vOffset: FBOffset) -> Int32 {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return 0
        }
        return _bb.dataGetInt32(offset: offset)
    }
    
    public final func getUInt32(vOffset: FBOffset) -> UInt32 {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return 0
        }
        return _bb.dataGetUInt32(offset: offset)
    }
    
    public final func getInt64(vOffset: FBOffset) -> Int64 {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return 0
        }
        return _bb.dataGetInt64(offset: offset)
    }
    
    public final func getUInt64(vOffset: FBOffset) -> UInt64 {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return 0
        }
        return _bb.dataGetUInt64(offset: offset)
    }
    
    public final func getFloat32(vOffset: FBOffset) -> Float32 {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return 0
        }
        return _bb.dataGetFloat32(offset: offset)
    }
    
    public final func getFloat64(vOffset: FBOffset) -> Float64 {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return 0
        }
        return _bb.dataGetFloat64(offset: offset)
    }
    
    public final func getString(vOffset: FBOffset) -> String? {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return nil
        }
        return _bb.dataGetString(offset: offset)
    }
    
    public final func getStruct<T: FBTable>(type: T.Type, vOffset: FBOffset) -> T? {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return nil
        }
        let s = type.init(pos: offset, bb: _bb)
        return s
    }
    
    public final func getTable<T: FBTable>(type: T.Type, vOffset: FBOffset) -> T? {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return nil
        }
        return type.init(pos: indirect(offset: offset), bb: _bb)
    }
    
    public final func getStrings(vOffset: FBOffset) -> [String]? {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return nil
        }
        let length = getVectorLength(vOffset: vOffset)
        guard length > 0 else {
            return nil
        }
        var list = [String]()
        if vOffset > 0 {
            for i in 0..<length {
                if let s = _bb.dataGetString(offset: getVector(vOffset: vOffset) + i * 4) {
                    list.append(s)
                }
            }
        }
        return list
    }
    
    public final func getStructs<T: FBTable>(type: T.Type, vOffset: FBOffset, byteSize: FBOffset) -> [T]? {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return nil
        }
        let length = getVectorLength(vOffset: vOffset)
        guard length > 0 else {
            return nil
        }
        var list = [T]()
        if vOffset > 0 {
            for i in 0..<length {
                let offset = getVector(vOffset: vOffset) + i * byteSize
                if let s = type.init(pos: offset, bb: _bb) {
                    list.append(s)
                }
            }
        }
        return list
    }
    
    public final func getTables<T: FBTable>(type: T.Type, vOffset: FBOffset) -> [T]? {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return nil
        }
        let length = getVectorLength(vOffset: vOffset)
        guard length > 0 else {
            return nil
        }
        var list = [T]()
        if vOffset > 0 {
            for i in 0..<length {
                let offset = indirect(offset: getVector(vOffset: vOffset) + i * 4)
                if let s = type.init(pos: offset, bb: _bb) {
                    list.append(s)
                }
            }
        }
        return list
    }
    
    public final func getNumbers<T>(vOffset: FBOffset) -> [T]? {
        let pOffset = getOffset_p(vOffset: vOffset)
        let offset = getOffset(vOffset: vOffset, pOffset: pOffset)
        if offset == 0 {
            return nil
        }
        let length = getVectorLength(vOffset: vOffset)
        guard length > 0 else {
            return nil
        }
        var list = [T]()
        let size = MemoryLayout<T>.size
        if vOffset > 0 {
            for i in 0..<length {
                let offset = getVector(vOffset: vOffset) + FBOffset(Int(i) * size)
                if let s = _bb.dataGet(offset: offset) as T? {
                    list.append(s)
                }
            }
        }
        return list
    }
}

// MARK: - Serialization
extension FBTable {
    private final func put(table: FBTable, offset: FBOffset) {
        let data = table.toFBData()
        if table.isFixed {
            _bb.dataSet(offset: offset, data: data)
        } else {
            _bb.dataSet(offset: offset,
                        value: _bb.length - offset + table.hardPos,
                        length: 4)
            _bb.dataAppend(data: data)
        }
    }
    
    private final func put(str: String, offset: FBOffset) {
        if let strData = str.data(using: .utf8) {
            var strLen = strData.count
            _bb.dataSet(offset: offset,
                        value: _bb.length - offset,
                        length: 4)
            let lenData = Data(bytes: &strLen,
                               count: 4)
            _bb.dataAppend(data: lenData)
            _bb.dataAppend(data: strData)
        } else {
            assert(false)
        }
    }
    
    private final func put(arr: Array<Any>, offset: FBOffset) {
        let arrLength = arr.count
        var pointerData: FBBufferData!
        var contentData = Data()
        if let _arr = arr as? Array<FBTable> {
            pointerData = _arr[0].isFixed ? FBBufferData(capacity: 4) : FBBufferData(capacity: UInt(arrLength + 1) * 4)
            for i in 0..<arrLength {
                let table = _arr[i]
                let tableData = table.toFBData()
                if table.isFixed == false {
                    let k = FBOffset(i * 4 + 4)
                    pointerData.dataSet(offset: k,
                                        value: FBOffset(contentData.count) - k + table.hardPos + pointerData.length,
                                        length: 4)
                }
                contentData.append(tableData)
            }
        } else if let _arr = arr as? Array<String> {
            pointerData = FBBufferData(capacity: UInt(arrLength + 1) * 4)
            for i in 0..<arrLength {
                let str = _arr[i]
                if let strData = str.data(using: .utf8) {
                    let k = FBOffset(i * 4 + 4)
                    pointerData.dataSet(offset: k,
                                        value: FBOffset(contentData.count) - k + pointerData.length,
                                        length: 4)
                    var strLen = strData.count
                    let lenData = Data(bytes: &strLen, count: 4)
                    contentData.append(lenData)
                    contentData.append(strData)
                } else {
                    assert(false)
                }
            }
        } else {
            var length = 0
            if arr is [UInt8] || arr is [Int8] || arr is [Bool] {
                length = 1
            } else if arr is [Int16] || arr is [UInt16] {
                length = 2
            } else if arr is [Int32] || arr is [Float32] || arr is [Float32] {
                length = 4
            } else if arr is [Int64] || arr is [UInt64] || arr is [Float64] {
                length = 8
            } else {
                assert(false)
            }
            pointerData = FBBufferData(capacity: UInt(arrLength * length + 4))
            for i in 0..<arrLength {
                let k = FBOffset(i * length + 4)
                pointerData.dataSet(offset: k,
                                    value: arr[i],
                                    length: FBOffset(length))
            }
        }
        pointerData.dataSet(offset: 0, value: arrLength, length: 4)
        pointerData.dataAppend(data: contentData)
        _bb.dataSet(offset: offset, value: _bb.length - offset, length: 4)
        _bb.dataAppend(data: pointerData)
    }
    
    public final func set<T>(vOffset: FBOffset, pOffset: FBOffset, value: T?) {
        if let v = value {
            let offset = isFixed ? vOffset : pOffset + _bbPos
            if let arr = v as? Array<Any> {
                if arr.count == 0 {
                    return
                }
                put(arr: arr, offset: offset)
            } else if let t = v as? FBTable {
                put(table: t, offset: offset)
            } else if let s = v as? String {
                put(str: s, offset: offset)
            } else {
                let length = MemoryLayout.size(ofValue: v)
                _bb.dataSet(offset: offset, value: v, length: FBOffset(length))
            }
            if isFixed == false {
                _bb.dataSet(offset: vTable + vOffset, value: pOffset, length: 2)
            }
        }
    }
}

extension FBTable {
    fileprivate final func getOffset_p(vOffset: FBOffset) -> FBOffset {
        return FBOffset(_bb.dataGetInt16(offset: vOffset + vTable))
    }
    
    fileprivate final func getOffset(vOffset: FBOffset, pOffset: FBOffset) -> FBOffset {
        if isFixed {
            return _bbPos + vOffset
        }
        if pOffset == 0 {
            return 0
        }
        if vOffset >= _bb.dataGetUInt8(offset: vTable) {
            return 0
        }
        return FBOffset(pOffset) + _bbPos
    }
    
    fileprivate final func getVector(vOffset: FBOffset) -> FBOffset {
        let o = getOffset(vOffset: vOffset, pOffset: getOffset_p(vOffset: vOffset))
        return o + _bb.dataGetInt32(offset: o) + 4
    }
    
    fileprivate final func getVectorLength(vOffset: FBOffset) -> FBOffset {
        let pOffset = getOffset_p(vOffset: vOffset)
        var o = getOffset(vOffset: vOffset, pOffset: pOffset)
        o += _bb.dataGetInt32(offset: o)
        return _bb.dataGetInt32(offset: o)
    }
    
    fileprivate final func indirect(offset: FBOffset) -> FBOffset {
        return _bb.dataGetInt32(offset: offset) + offset
    }
}

// MARK: - Get
public class FBBufferData {
    fileprivate final var _data: Data
    fileprivate init(data: Data) {
        _data = data
    }
    
    public init(capacity: UInt) {
        _data = Data(count: Int(capacity))
    }
    
    fileprivate final var length: Int32 {
        return Int32(_data.count)
    }
    
    fileprivate final func dataGetBool(offset: FBOffset) -> Bool {
        return(dataGet(offset: offset) as Bool?) ?? false
    }
    
    fileprivate final func dataGetInt8(offset: FBOffset) -> Int8 {
        return(dataGet(offset: offset) as Int8?) ?? 0
    }
    
    fileprivate final func dataGetUInt8(offset: FBOffset) -> UInt8 {
        return(dataGet(offset: offset) as UInt8?) ?? 0
    }
    
    fileprivate final func dataGetInt16(offset: FBOffset) -> Int16 {
        return(dataGet(offset: offset) as Int16?) ?? 0
    }
    
    fileprivate final func dataGetUInt16(offset: FBOffset) -> UInt16 {
        return(dataGet(offset: offset) as UInt16?) ?? 0
    }
    
    fileprivate final func dataGetInt32(offset: FBOffset) -> Int32 {
        return (dataGet(offset: offset) as Int32?) ?? 0
    }
    
    fileprivate final func dataGetUInt32(offset: FBOffset) -> UInt32 {
        return (dataGet(offset: offset) as UInt32?) ?? 0
    }
    
    fileprivate final func dataGetInt64(offset: FBOffset) -> Int64 {
        return (dataGet(offset: offset) as Int64?) ?? 0
    }
    
    fileprivate final func dataGetUInt64(offset: FBOffset) -> UInt64 {
        return (dataGet(offset: offset) as UInt64?) ?? 0
    }
    
    fileprivate final func dataGetFloat32(offset: FBOffset) -> Float32 {
        return (dataGet(offset: offset) as Float32?) ?? 0
    }
    
    fileprivate final func dataGetFloat64(offset: FBOffset) -> Float64 {
        return (dataGet(offset: offset) as Float64?) ?? 0
    }
    
    fileprivate final func dataGet<T>(offset: FBOffset) -> T? {
        return _data.dataGet_(offset: offset)
    }
    
    fileprivate final func dataGetString(offset: FBOffset) -> String? {
        let offset = offset + dataGetInt32(offset: offset)
        let length = dataGetInt32(offset: offset)
        if let data = _data.subdata_(offset: offset + 4, length: length) {
            let s = String(data: data, encoding: .utf8)
            return s != "" ? s : nil
        }
        return nil
    }
}

// MARK: - Set
extension FBBufferData {
    fileprivate final func dataSet<T>(offset: FBOffset, value: T, length: FBOffset) {
        _data.dataSet_(offset: offset, value: value, length: length)
    }
    
    fileprivate final func dataSet(offset: FBOffset, data: Data) {
        _data.dataSet_(offset: offset, data: data)
    }
    
    fileprivate final func dataAppend(data: Data) {
        _data.append(data)
    }
    
    fileprivate final func dataAppend(data: FBBufferData) {
        _data.append(data._data)
    }
}

// MARK: - Operate data
extension Data {
    fileprivate func subdata_(offset: FBOffset, length: FBOffset) -> Data? {
        var upper = offset + length
        upper = FBOffset(count) >= upper ? upper: offset
        if upper > FBOffset(count) {
            return nil
        }
        return subdata(in: Range(uncheckedBounds: (lower: Int(offset), upper: Int(upper))))
    }
    
    fileprivate func dataGet_<T>(offset: FBOffset) -> T? {
        let length = MemoryLayout<T>.size
        if let data = subdata_(offset: offset, length: FBOffset(length)) {
            let bytes = (data.withUnsafeBytes {
                [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
            }) as [UInt8]
            let res = fromByteArray_(bytes, T.self)
            return res
        }
        return nil
    }
    
    fileprivate mutating func dataSet_(offset: FBOffset, data: Data) {
        let upper = offset + FBOffset(data.count)
        replaceSubrange(Range(uncheckedBounds: (lower: Int(offset), upper: Int(upper))),
                        with: data)
    }
    
    fileprivate mutating func dataSet_<T>(offset: FBOffset, value: T, length: FBOffset) {
        var value = value
        let upper = offset + FBOffset(length)
        let data = Data(bytes: &value,
                        count: Int(length))
        replaceSubrange(Range(uncheckedBounds: (lower: Int(offset), upper: Int(upper))),
                        with: data)
    }
}

// MARK: http://stackoverflow.com/questions/26953591/how-to-convert-a-double-into-a-byte-array-in-swift
private func fromByteArray_<T>(_ value: [UInt8], _: T.Type) -> T {
    return value.withUnsafeBufferPointer {
        $0.baseAddress!.withMemoryRebound(to: T.self, capacity: 1) {
            $0.pointee
        }
    }
}
