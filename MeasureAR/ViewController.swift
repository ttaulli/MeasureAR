//
//  ViewController.swift
//  MeasureAR
//
//  Created by Tom Taulli on 8/22/17.
//  Copyright © 2017 Taulli's Taxes. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    var txtNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodes.count >= 2 {
            
            for dot in dotNodes {
                
                dot.removeFromParentNode()
                
            }
            
            dotNodes = [SCNNode]()
            
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) {
        
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first {
                
                addDot(at: hitResult)
                
            }
        
        }
        
        
    }
    
    func addDot(at hitResult : ARHitTestResult) {
        
        let dotGeometry = SCNSphere (radius: 0.005)
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3Make(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            
            getDistance()
            
        }
        
    }
    
    func getDistance() {
        
        let startNode = dotNodes[0]
        
        let endNode = dotNodes[1]
        
        let a = endNode.position.x - startNode.position.x
        
        let b = endNode.position.y - startNode.position.y
        
        let c = endNode.position.z - startNode.position.z
        
        let distanceInches = abs(sqrt(pow(a, 2) + pow(b, 2) + pow(c,2)) / 0.0254)
    
        let distanceString = String(format: "%.2f", distanceInches)
        
        let txtGeometry = SCNText(string: distanceString, extrusionDepth: 1.0)
        
        txtGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        txtNode.removeFromParentNode()
        
        txtNode = SCNNode(geometry: txtGeometry)
        
        txtNode.position = SCNVector3(startNode.position.x, startNode.position.y + 0.01, startNode.position.z)
        
        txtNode.scale = SCNVector3(0.005, 0.005, 0.005)
        
        sceneView.scene.rootNode.addChildNode(txtNode)
        
        
    }
    
}


