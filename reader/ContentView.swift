//
//  ContentView.swift
//  reader
//
//  Created by Kevin Tram on 10/8/26.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var page = WebPage()

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

#Preview {
    ContentView()
}
