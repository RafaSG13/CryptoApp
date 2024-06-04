//
//  XmarkButton.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 1/6/24.
//

import SwiftUI

struct XmarkButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
         Button(action: {
             presentationMode.wrappedValue.dismiss()
         }, label: {
             Image(systemName: "xmark")
                 .font(.headline)
         })
    }
}

#Preview {
    XmarkButton()
}
