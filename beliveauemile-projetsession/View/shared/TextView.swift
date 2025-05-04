//
//  TextView.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import Foundation
import SwiftUI

extension Text  {
  func TextCustom(colorFore: Color = .black, colorBack: Color = .white) -> some View {
    self
      .padding()
      .foregroundColor(colorFore)
      .background(colorBack)
      .cornerRadius(10.0)
  }
}
