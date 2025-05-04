//
//  TextFieldView.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import Foundation
import SwiftUI

extension TextField  {
  func TextFieldCustom() -> some View {
    self
      .padding()
      .background(Color.white)
      .cornerRadius(10)
      .shadow(radius: 3)
      .padding(.horizontal)
      .padding(.bottom)
  }
}
