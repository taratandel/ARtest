//
//  ViewController.swift
//  ARTest
//
//  Created by Tara Tandel on 7/20/1397 AP.
//  Copyright © 1397 Tara Tandel. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController {
    
    // every AR program should start with an AR session, an ARSCNView has ARSession in its object
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBoxes()
        addTapGestureToSceneView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let config = ARWorldTrackingConfiguration()
        
        sceneView.session.run(config)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // I wont resume once we paused but from ios 12 this feature was added
        sceneView.session.pause()
    }
    
    func addBoxes(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        //  Create a box shape. 1 Float = 1 meter.
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        //Create a node. A node represents the position and the coordinates of an object in a 3D space. By itself, the node has no visible content.
        let boxNode = SCNNode()
        //  We can give the node a visible content by giving it a shape. We do this by setting the node’s geometry to the box.
        boxNode.geometry = box
        //  we give our node a position. This position is relative to the camera. Positive x is to the right. Negative x is to the left. Positive y is up. Negative y is down. Positive z is backward. Negative z is forward.
        boxNode.position = SCNVector3(x, y, z)
        // We then add our box node to the root node of the scene. A root node in a scene that defines the coordinate system of the real world rendered by SceneKit.
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        //First, we perform a hit test we specify a .featurePoint result type for the types parameter. The types parameter asks the hit test to search for real-world objects or surfaces detected through the AR session’s processing of the camera image.
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        // beacuse ARKit may not always detect a real world object or a surface in the real world.
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                // we transform the matrix of type matrix_float4x4 to float3
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                addBoxes(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }
}
// the Geometric calculations I dont understande :\
extension float4x4 {
    // This extension basically transforms a matrix into float3. It gives us the x, y, and z from the matrix.
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
