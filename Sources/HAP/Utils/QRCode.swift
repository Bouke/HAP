import Foundation

#if os(macOS)
import Cocoa
#endif

class QRCode {

    let string: String

    public init(from: String) {
        self.string = from
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
