//
//  CloseButton.swift
//  Clipboard Notifications
//
//  Created by Adrian Gri on 2024-11-02.
//

import SwiftUI

struct CloseButton: View {
    var body: some View {
        Button(action: quit) {
            Text("Quit")
                .font(.headline)
                .fontWeight(.semibold)
        }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .center)
            .onHover(perform: handleHover)
    }
}
