//
//  Avatars.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 25.02.2022.
//

import SwiftUI

struct ImageAvatar: View {
    let image: UIImage?
    let frame: CGSize

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .background(Color.white)
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .padding()
                    .foregroundColor(Palette.accent)
            }
        }
        .frame(width: frame.width, height: frame.height)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Palette.whiteLight, lineWidth: 1)
                .frame(width: frame.width - 0.5, height: frame.height - 0.5)
        )
    }
}

struct TextAvatar: View {
    var textForIcon: String
    var frame: CGSize
    var strokeColor: Color

    var body: some View {
        Text("\(textForIcon)")
            .frame(width: frame.width, height: frame.height)
            .background {
                ZStack {
                    Circle()
                        .fill(.black.opacity(0.0001))
                    Circle()
                        .stroke()
                        .foregroundColor(strokeColor)
                }
            }
    }
}
