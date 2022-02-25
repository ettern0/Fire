//
//  PhotoInfo.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 23.02.2022.
//

import Foundation

final class PhotosInfo: ObservableObject {

    @Published var photos: [RemotePhoto] = []
    static let instance = PhotosInfo()
    private let imageService = DownloadImageService()
    private var isFetchingInProgress: Bool = false
    private var isFetchingPlanned: Bool = false

    private init() {
        self.photos = []

        imageService.addImageListener { [weak self] in
            self?.fetchIfNeeded()
        }
    }

    func fetchIfNeeded() {
        if isFetchingInProgress {
            isFetchingPlanned = true
        } else {
            fetchPhotosInfo()
        }
    }

    private func fetchPhotosInfo() {
        self.isFetchingInProgress = true
        self.isFetchingPlanned = false

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        imageService.download { value in
            self.photos = value
        }
        dispatchGroup.leave()

        dispatchGroup.notify(queue: .main) {
            self.isFetchingInProgress = false
            if self.isFetchingPlanned {
                self.fetchIfNeeded()
            }
        }
    }

}
