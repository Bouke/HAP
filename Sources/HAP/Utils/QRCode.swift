import CQRCode
import Foundation

#if os(macOS)
import Cocoa
#endif

public struct QRCode {
    let string: String

    init(from: String) {
        self.string = from
    }

    public var asBitmap: [[Bool]] {
        var qrcode = CQRCode.QRCode()
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CQRCode.qrcode_getBufferSize(1)))
        let returnValue = string.withCString { stringPointer in
            CQRCode.qrcode_initText(&qrcode, buffer, 1, UInt8(CQRCode.ECC_MEDIUM), stringPointer)
        }
        precondition(returnValue == 0, "QRCode generation failed")
        return (0..<qrcode.size).map { y in
            (0..<qrcode.size).map { x in
                CQRCode.qrcode_getModule(&qrcode, x, y) == 1
            }
        }
    }

    public var asText: String {
        let bitmap = asBitmap
        return stride(from: 0, to: bitmap.count, by: 2)
            .map { y in
                let lower = bitmap[y]
                let upper = y > 0 ? bitmap[y - 1] : [Bool](repeating: false, count: lower.count)
                return zip(upper, lower)
                    .map { pixel in
                        switch pixel {
                        case (false, false): return " "
                        case (true, false): return "▀"
                        case (false, true): return "▄"
                        case (true, true): return "█"
                        }
                    }
                    .joined()
            }
            .joined(separator: "\n")
    }

    public var asBigText: String {
        let bitmap = asBitmap
        return (0..<bitmap.count)
            .map { y in
                bitmap[y]
                    .map { $0 ? "██" : "  " }
                    .joined()
            }
            .joined(separator: "\n")
    }

    public var asASCII: String {
        let bitmap = asBitmap
        return (0..<bitmap.count)
            .map { y in
                bitmap[y]
                    .map { $0 ? "##" : "  " }
                    .joined()
            }
            .joined(separator: "\n")
    }

#if os(macOS)
    public var asCIImage: CIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return output //UIImage(ciImage: output)
            }
        }
        return nil
    }

    public var asNSImage: NSImage? {
        if let ciImage = asCIImage {
            let rep: NSCIImageRep = NSCIImageRep(ciImage: ciImage)
            let nsImage: NSImage = NSImage(size: rep.size)
            nsImage.addRepresentation(rep)
            return nsImage
        }
        return nil
    }
#endif
}
