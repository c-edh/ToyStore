//
//  ARView + Extension.swift
//  ToyStore
//
//  Created by Corey Edh on 9/12/24.
//

import Foundation
import ARKit
import RealityKit


extension ARView {
    func addCoachingOverlay() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        self.addSubview(coachingOverlay)
    }
}
