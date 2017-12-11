//
//  ViewController.swift
//  AoC-Day8
//
//  Created by Frank Guchelaar on 08/12/2017.
//  Copyright © 2017 Awesomation. All rights reserved.
//

import UIKit
import ARKit
import ARCharts

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var barChart = ARBarChart()
    var dataSeries: ARDataSeries?
    
    var registers = [String: Int]()
    var registerNames: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        file = Bundle.main.url(forResource: "input", withExtension: "txt")!
        input = try! String(contentsOf: file)
        instructions = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        registerNames = Array(Set(instructions.map { $0.components(separatedBy: " ")[0] }))

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        self.view.addGestureRecognizer(tap)
        
        setupSceneView()
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        if !running {
            running = true
            startInstructions(instructions: instructions)
        }
    }
    
    func setupSceneView() {
        sceneView.delegate = self
        //        sceneView.debugOptions = [.showWireframe, .showBoundingBoxes, .showCameras]
        sceneView.showsStatistics = false
        sceneView.antialiasingMode = .multisampling4X
        sceneView.preferredFramesPerSecond = 60
        sceneView.automaticallyUpdatesLighting = false
        
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
            camera.exposureOffset = -1
            camera.minimumExposure = -1
        }
        
        addLightSource(ofType: .omni)
    }
    
    private func addLightSource(ofType type: SCNLight.LightType, at position: SCNVector3? = nil) {
        let light = SCNLight()
        light.color = UIColor.white
        light.type = type
        light.intensity = 1500 // Default SCNLight intensity is 1000
        
        let lightNode = SCNNode()
        lightNode.light = light
        if let lightPosition = position {
            // Fix the light source in one location
            lightNode.position = lightPosition
            self.sceneView.scene.rootNode.addChildNode(lightNode)
        } else {
            // Make the light source follow the camera position
            self.sceneView.pointOfView?.addChildNode(lightNode)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func reloadBarCart() {
        if self.barChart.dataSource != nil {
            self.barChart.childNodes.forEach { $0.removeFromParentNode() }
            self.barChart.reloadGraph()
        }
    }
    
    func addBarChart(to node: SCNNode) {
        
        barChart.position = SCNVector3(0, 0, 0)
        barChart.animationType = .none
        barChart.size = SCNVector3(0.2,0.3,0.015)
        barChart.maxValue = 8022
        barChart.dataSource = self
        barChart.delegate = self
        barChart.draw()
        
        node.addChildNode(barChart)
    }
    
    func startInstructions(instructions: [String]) {
        
        DispatchQueue.global().async {
            for instruction in instructions {
                let parts = instruction.components(separatedBy: " ")
                
                var shouldExecute = false
                switch parts[5] {
                case ">":
                    shouldExecute = (self.registers[parts[4]] ?? 0) > Int(parts[6])!
                case "<":
                    shouldExecute = (self.registers[parts[4]] ?? 0) < Int(parts[6])!
                case ">=":
                    shouldExecute = (self.registers[parts[4]] ?? 0) >= Int(parts[6])!
                case "<=":
                    shouldExecute = (self.registers[parts[4]] ?? 0) <= Int(parts[6])!
                case "==":
                    shouldExecute = (self.registers[parts[4]] ?? 0) == Int(parts[6])!
                case "!=":
                    shouldExecute = (self.registers[parts[4]] ?? 0) != Int(parts[6])!
                default:
                    print("illegal operator: \(parts[5])")
                }
                
                if shouldExecute {
                    if parts[1] == "inc" {
                        self.registers[parts[0]] = (self.registers[parts[0]] ?? 0) + Int(parts[2])!
                    }
                    else {
                        self.registers[parts[0]] = (self.registers[parts[0]] ?? 0) - Int(parts[2])!
                    }
                }
                
                DispatchQueue.main.async {
                    self.reloadBarCart()
                    //                    let max = self.registers
                    //                        .sorted { $0.value < $1.value }
                    //                        .first!
                    //                    let reg = self.registerNames.index(of: max.key)
                    //                    self.barChart.highlightIndex(reg!, withAnimationStyle: .fade, withAnimationDuration: 0)
                }
                
                
                
                let ms = 1000
                usleep(useconds_t(50 * ms))
                //            // For part two
                //            highestValue = max(registers.values.map { $0 }.max()!, highestValue)
            }
            
            //            let maxValue = self.registers.values.map { $0 }.max()!
            
            //        print ("Part one: \(maxValue)")
            //        print ("Part two: \(highestValue)")        }
            
            //        var highestValue = 0
            
            
            DispatchQueue.main.async {
                let maxValue = self.registers.values.map { $0 }.max()!
                
                let label = UILabel()
                label.text = "\(maxValue)"
                label.backgroundColor = UIColor.white
                label.textAlignment = .center
                label.sizeToFit()
                label.frame.origin = CGPoint(x: self.view.bounds.midX, y: 30)
                
                self.view.addSubview(label)
            }
            //
            //            guard let pointOfView = self.sceneView.pointOfView else { return }
            //
            //            let text = SCNText(string: "\(maxValue)", extrusionDepth: 4)
            //            let textNode = SCNNode(geometry: text)
            //            textNode.geometry = text
            ////            textNode.simdPosition = pointOfView.simdPosition + pointOfView.simdWorldFront * 0.5
            //            textNode.position = SCNVector3Make(pointOfView.position.x, pointOfView.position.y, pointOfView.position.z)
            //            self.barChart.addChildNode(textNode)
        }
    }
    var running = false
    var file : URL!
    var input : String!
    var instructions : [String]!
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("ADD: \(node)\t\(anchor)")
        //        node.geometry = SCNPlane(width: 1, height: 1)
        
        addBarChart(to: node)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("REMOVE: \(node)\t\(anchor)")
        barChart.removeFromParentNode()
    }
    
    
    //    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    //        print("REMOVE: \(node)\t\(anchor)")
    //        barChart.removeFromParentNode()
    //        addBarChart(to: node)
    //    }
}

extension ViewController: ARBarChartDataSource {
    func random(max maxNumber: Int) -> Double {
        return Double(arc4random_uniform(UInt32(maxNumber)))
    }
    
    func numberOfSeries(in barChart: ARBarChart) -> Int {
        return 1
    }
    
    func barChart(_ barChart: ARBarChart, numberOfValuesInSeries series: Int) -> Int {
        return registerNames.count
    }
    
    func barChart(_ barChart: ARBarChart, valueAtIndex index: Int, forSeries series: Int) -> Double {
        
        if !running {
            return 1.0
        }
        
        let name = registerNames[index]
        return Double(registers[name] ?? 0)
    }
    
    func barChart(_ barChart: ARBarChart, labelForValuesAtIndex index: Int) -> String? {
        return registerNames[index]
    }
    
    public func barChart(_ barChart: ARBarChart, gapSizeAfterIndex index: Int) -> Float {
        return 0.2
    }
}

extension ViewController: ARBarChartDelegate {
    func barChart(_ barChart: ARBarChart, opacityForBarAtIndex index: Int, forSeries series: Int) -> Float {
        return 0.9
    }
    
    func barChart(_ barChart: ARBarChart, chamferRadiusForBarAtIndex index: Int, forSeries series: Int) -> Float {
        return 0
    }
    
    func barChart(_ barChart: ARBarChart, colorForBarAtIndex index: Int, forSeries series: Int) -> UIColor {
        
        let colors = [
            UIColor.red,
            UIColor.white,
            UIColor.blue
        ]
        
        return colors[index % colors.count]
    }
}

