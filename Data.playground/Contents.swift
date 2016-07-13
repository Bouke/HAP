import Foundation

func decode(data: Data) -> [UInt8: Data] {
    var result = [UInt8: Data]()
    var index = data.startIndex
    while index < data.endIndex {
        let type = data[index]
        index = data.index(after: index)

        let length = Int(data[index])
        index = data.index(after: index)

        let to = data.index(index, offsetBy: length)
        let bytes = data[index..<to]
        result[type] = Data(bytes: Array(bytes))
        index = to
    }
    return result
}



let step1 = Data(bytes: [0,1,0,6,1,1])
print(decode(data: step1))


func encode(data: [UInt8: Data]) -> Data {
    var result = Data()
    for (type, value) in data {
        result.append(Data(bytes: [type, UInt8(value.count)] + Array(value)))
    }
    return result
}


print(decode(data: encode(data: [0: Data(bytes: [0]), 6: Data(bytes: [1])])))

var result = Int16(0)
for byte in Data(bytes: [0xfa, 0xff]) {
    result <<= 8
    result |= Int16(byte)
}
//result.

//UnsafePointer<Int16>(step1.bytes)

//func integerWithBytes<T: Integer>(bytes:[UInt8]) -> T {
//}

//integerWithBytes(bytes: [1]) as UInt8
//integerWithBytes(bytes: [1]) as Int16
//integerWithBytes(bytes: [1, 1]) as Int16


extension Integer {
    init(bytes: [UInt8]) {
        precondition(bytes.count == sizeof(Self), "incorrect number of bytes")
        self = bytes.withUnsafeBufferPointer() {
            return UnsafePointer($0.baseAddress!).pointee
        }
    }

    init(data: Data) {
        self.init(bytes: Array(data))
    }
}

UInt8.init(bytes: [1])
UInt8.init(data: Data(bytes: [1]))
Int16.init(bytes: [0xf0, 1])
