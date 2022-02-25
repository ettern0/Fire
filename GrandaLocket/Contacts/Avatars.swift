//
//  Avatars.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 25.02.2022.
//

import SwiftUI

struct imageAvatar: View {
    var image: UIImage
    var frame: CGSize

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: frame.width, height: frame.height)
            .clipShape(Circle())
    }
}

struct textAvatar: View {
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
