//
//  ImageView.swift
//  beliveauemile-projetsession
//
//  Created by Eme Beau on 2024-05-13.
//

import Foundation
import SwiftUI

extension Image  {
  func ImageCustom(height: CGFloat?, width: CGFloat?) -> some View {
    self
      .resizable()
      .scaledToFit()
      .frame(width: width, height: height, alignment: .center)
      .padding(.horizontal)
  }
}
