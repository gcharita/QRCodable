//
//  ContentView.swift
//  QRCodable
//
//  Created by Giorgos Charitakis on 1/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isFileExporterPresented = false
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                TextField("Enter text to encode", text: $viewModel.text, axis: .vertical)
                    .lineLimit(6...)
                    .scrollDisabled(false)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: 600)
                    .onChange(of: viewModel.text, initial: false) { _, _ in
                        viewModel.encode()
                    }
            }
            .frame(minWidth: 600, maxWidth: 600, minHeight: 100, maxHeight: 100)
            Spacer().frame(height: 10)
            HStack(alignment: .center) {
                Text("Scale: ")
                TextField("Scale", text: $viewModel.selectedScale)
                    .frame(maxWidth: 50)
                    .onChange(of: viewModel.selectedScale, initial: false) { _, _ in
                        viewModel.encode()
                    }
                Spacer().frame(width: 20)
                if viewModel.image != nil {
                    Button("Save") {
                        isFileExporterPresented = true
                    }
                    .fileExporter(isPresented: $isFileExporterPresented, document: viewModel.imageFile, contentType: .png, defaultFilename: "QRCodable_image.png") { result in
                        switch result {
                        case .success(let url):
                            print("Image saved to \(url)")
                        case .failure(let error):
                            print("Image failed to saved: \(error)")
                        }
                    }
                }
            }
            if let image = viewModel.image {
                Spacer().frame(height: 10)
                Image(nsImage: image)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: .init())
}
