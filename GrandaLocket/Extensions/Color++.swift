//
//  Color++.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 14.02.2022.
//

import SwiftUI

extension Color {
    init(rgb: UInt32) {
        self.init(UIColor(rgb: rgb))
    }
}
