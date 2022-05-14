//
//  ThemeSettings.swift
//  TODO
//
//  Created by Zeyad Badawy on 14/05/2022.
//

import SwiftUI

final public class ThemeSettings: ObservableObject {
  @Published public var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
    didSet {
      UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
    }
  }
 
  private init() {}
  public static let shared = ThemeSettings()
}
