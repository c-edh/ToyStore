//
//  ToyStoreCoordinator.swift
//  ToyStore
//
//  Created by Corey Edh on 9/12/24.
//

import Foundation
import ARKit
import RealityKit
import Combine


class ToyStoreCoordinator {
    var arView: ARView?
    var cancellables: Cancellable?

    let viewModel: ToyStoreViewModel


    init(_ viewModel: ToyStoreViewModel ) {
        self.viewModel = viewModel
    }


    @objc func didTap(_ recongizer: UITapGestureRecognizer) {
        guard let arView else {
            return
        }

        let location = recongizer.location(in: arView)

        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)

        if let results = results.first {
            let anchor = AnchorEntity(raycastResult: results)

            guard let selectedToy = viewModel.selectedToy else {
                return
            }
            self.cancellables = ModelEntity.loadAsync(named: selectedToy.rawValue).sink { [weak self] loadCompletion in
                if case let .failure(error) = loadCompletion {
                    print("Fail to load model")
                }
                self?.cancellables?.cancel()
            } receiveValue: { entity in
                anchor.addChild(entity)
            }

            arView.scene.addAnchor(anchor)
        }

    }
}
