//
//  TextEditorView.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import Foundation
import SwiftUI

extension TextEditor  {
  func TextEditorCustom() -> some View {
    self
      .padding()
      .background(Color.white)
      .cornerRadius(10)
      .shadow(radius: 3)
      .padding(.horizontal)
      .padding(.bottom)
      .frame(minHeight: 250, maxHeight: 350)
  }
}
