//
//  ContentView.swift
//  reader
//
//  Created by Kevin Tram on 10/8/26.
//

import SwiftUI
import UniformTypeIdentifiers
import WebKit

struct ContentView: View {
    @State private var page = WebPage(dialogPresenter: DialogPresenter())

    var body: some View {
        WebView(page)
            .navigationTitle(page.title)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Top", systemImage: "arrow.up") {
                        Task { try? await page.callJavaScript("scrollTo(0, 0)") }
                    }
                }
            }
            .onAppear {
                page.load(URLRequest(url: Bundle.main.url(forResource: "index", withExtension: "html")!))
            }
    }
}

// WebPage ignores alert() and <input type="file"> unless something presents
// them, so the page's error alert and "choose one" link need this.
private struct DialogPresenter: WebPage.DialogPresenting {
    func handleJavaScriptAlert(message: String, initiatedBy frame: WebPage.FrameInfo) async {
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
    }

    func handleFileInputPrompt(parameters: WKOpenPanelParameters, initiatedBy frame: WebPage.FrameInfo) async -> WebPage.FileInputPromptResult {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.epub]
        return panel.runModal() == .OK ? .selected(panel.urls) : .cancel
    }
}

#Preview {
    ContentView()
}
