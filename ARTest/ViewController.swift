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

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBox()
        addTapGestureToSceneView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /*
         The world tracking configuration tracks the device’s orientation and position. It also detects real-world surfaces seen through the device’s camera.
         */
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // I wont resume once we paused
        sceneView.session.pause()
    }
    
    func addBox() {
        //  Create a box shape. 1 Float = 1 meter.
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        //Create a node. A node represents the position and the coordinates of an object in a 3D space. By itself, the node has no visible content.
        let boxNode = SCNNode()
        //  We can give the node a visible content by giving it a shape. We do this by setting the node’s geometry to the box.
        boxNode.geometry = box
        //  we give our node a position. This position is relative to the camera. Positive x is to the right. Negative x is to the left. Positive y is up. Negative y is down. Positive z is backward. Negative z is forward.
        boxNode.position = SCNVector3(0, 0, -0.2)
        // Then we create a scene. This is the SceneKit scene to be displayed in the view. We then add our box node to the root node of the scene. A root node in a scene that defines the coordinate system of the real world rendered by SceneKit.
        let scene = SCNScene()
        scene.rootNode.addChildNode(boxNode)
        sceneView.scene = scene
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        // We retrieve the user’s tap location relative to the sceneView and hit test to see if we tap onto any node(s).
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        // Afterward, we safely unwrap the first node from our hitTestResults. If the result does contain at least a node, we will remove the first node we tapped on from its parent node.
        guard let node = hitTestResults.first?.node else { return }
        node.removeFromParentNode()
    }
}

