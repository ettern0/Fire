//
//  GaleryView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 25.02.2022.
//

import SwiftUI

struct GaleryView: View {
    let urls: Array<URL>
    let focus: URL

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { value in
                VStack {
                    ForEach(urls, id: \.self) { url in
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .background(.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding(.bottom, 15)
                    }
                }
                .onAppear {
                    withAnimation {
                        value.scrollTo(focus, anchor: .center)
                    }
                }
            }
        }
    }
}
