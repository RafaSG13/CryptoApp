//
//  SearchBarView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 31/5/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(searchText.isEmpty
                                 ? Color.theme.secondaryTextColor
                                 : Color.theme.accentColor)

            TextField("Search by name or symbol", text: $searchText)
                .foregroundStyle(Color.theme.accentColor)
                .autocorrectionDisabled(true)
                .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 5)
                    .foregroundStyle(Color.theme.accentColor)
                    .opacity(searchText.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        searchText = ""
                    }
                , alignment: .trailing)
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.backgroundColor)
                .shadow(color: Color.theme.accentColor.opacity(0.25),
                        radius: 10,x: 0, y: 0))
        .padding()
    }

}

#Preview {
    SearchBarView(searchText: .constant(""))
}
