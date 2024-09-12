//
//  ContentView.swift
//  ToyStore
//
//  Created by Corey Edh on 9/12/24.
//

import SwiftUI
import RealityKit
import ARKit

class ToyStoreViewModel: ObservableObject {
    @Published var selectedToy: ToyModel? = nil
}

struct ContentView : View {

    @StateObject var viewModel = ToyStoreViewModel()

    var body: some View {
        ARViewContainer(viewModel: viewModel)
            .edgesIgnoringSafeArea(.all)
            .safeAreaInset(edge: .bottom) {
                listOfToys
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
            }
    }

    @ViewBuilder
    var listOfToys: some View {
        ScrollView(.horizontal) {
            LazyHStack{
                ForEach(ToyModel.allCases, id: \.self) { toy in
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        withAnimation {
                            viewModel.selectedToy = toy
                        }
                    }, label: {
                        VStack {
                            Image(toy.rawValue)
                                .resizable()
                                .scaledToFit()
                                .opacity(viewModel.selectedToy == toy ? 1 : 0.5)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .frame(height: 200,alignment: .bottom)
                        .frame(maxWidth: 200)
                    })
                }
            }
        }
    }
}




struct ARViewContainer: UIViewRepresentable {

    let viewModel: ToyStoreViewModel

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.didTap)))

        let session = arView.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        session.run(config)
        let anchor = AnchorEntity(plane: .horizontal)

        context.coordinator.arView = arView

        arView.scene.anchors.append(anchor)
        arView.addCoachingOverlay()

        return arView

    }
    
    func makeCoordinator() -> ToyStoreCoordinator {
        ToyStoreCoordinator(viewModel)
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

}



#Preview {
    ContentView()
}
