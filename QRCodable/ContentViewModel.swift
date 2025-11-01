//
//  ContentViewModel.swift
//  QRCodable
//
//  Created by Giorgos Charitakis on 1/11/25.
//

import Foundation
import AppKit
import SwiftUI
import UniformTypeIdentifiers

class ContentViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var image: NSImage?
    @Published var selectedScale: String = "10"
    
    var imageFile: ImageFile? {
        guard let image else { return nil }
        return ImageFile(image: image)
    }
    
    func encode() {
        guard !text.isEmpty, let scale = Double(selectedScale) else { return }
        image = generateQRCode(from: text, scale: scale)
    }
    
    private func generateQRCode(from string: String, scale: CGFloat) -> NSImage? {
        let data = string.data(using: .ascii)

        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: scale, y: scale)

        guard let output = filter?.outputImage?.transformed(by: transform) else { return nil }
        
        let imageRepresentation = NSCIImageRep(ciImage: output)
        let image = NSImage(size: imageRepresentation.size)
        image.addRepresentation(imageRepresentation)
        return image
    }
}

struct ImageFile: FileDocument {
    private var pngData = Data()
    public static var readableContentTypes: [UTType] = [.png]
    
    init(image: NSImage) {
        guard let data = image.PNGRepresentation else { return }
        pngData = data
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else { return }
        pngData = data
    }
    
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: pngData)
    }
}

extension NSImage {
    /// A PNG representation of the image.
    var PNGRepresentation: Data? {
        guard let tiff = tiffRepresentation else { return nil }
        let tiffData = NSBitmapImageRep(data: tiff)
        return tiffData?.representation(using: .png, properties: [:])
    }
}
