//
//  AnyTransition++.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 14.02.2022.
//

import SwiftUI

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}
