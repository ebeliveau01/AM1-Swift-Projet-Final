//
//  SettingView.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import Foundation
import SwiftUI

struct SettingView: View {
  @Binding var accentColor: Color
  
  var body: some View {
    VStack {
      ColorPicker("Selection de la couleur du texte", selection: $accentColor)
        .padding(.horizontal)
      Spacer()
    }
    .navigationBarTitle("Parametre")
    .foregroundColor(accentColor)
  }
}
