import UIKit
import SceneKit
import ARKit
import PlaygroundSupport

class GameViewController: UIViewController, ARSCNViewDelegate {
    
    var scnView:ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        let baseNode = SCNNode()
        baseNode.position = SCNVector3(0, 0, -15)
        scene.rootNode.addChildNode(baseNode)
        
        let sunNode = SCNNode()
        let sun = SCNSphere(radius: 2.5)
        sun.firstMaterial?.diffuse.contents = UIImage(named:"sun.jpg")
        sunNode.geometry = sun
        sunNode.position = SCNVector3(0, 0, 0);
        
        let sunAnimation = CABasicAnimation(keyPath: "contentsTransform")
        sunAnimation.duration = 10
        sunAnimation.fromValue = NSValue.init(caTransform3D: 
            CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), 
                                CATransform3DMakeScale(3, 3, 3)))
        sunAnimation.toValue = NSValue.init(caTransform3D: 
            CATransform3DConcat(CATransform3DMakeTranslation(1, 1, 0), 
                                CATransform3DMakeScale(3, 3, 3)))
        sunAnimation.repeatCount = .infinity
        
        sun.firstMaterial?.diffuse.addAnimation(sunAnimation, forKey: nil)
        sun.firstMaterial?.multiply.addAnimation(sunAnimation, forKey: nil)
        
        baseNode.addChildNode(sunNode)
        
        sun.firstMaterial?.multiply.contents = UIImage(named:"sun.jpg")
        sun.firstMaterial?.multiply.intensity = 0.5;
        sun.firstMaterial?.lightingModel = .constant
        
        sun.firstMaterial?.diffuse.wrapS = .repeat
        sun.firstMaterial?.diffuse.wrapT = .repeat
        sun.firstMaterial?.multiply.wrapS = .repeat
        sun.firstMaterial?.multiply.wrapT = .repeat
        
        let earthRotationNode = SCNNode()
        sunNode.addChildNode(earthRotationNode)
        
        let earthGroupNode = SCNNode()
        earthGroupNode.position = SCNVector3(15, 0, 0)
        earthRotationNode.addChildNode(earthGroupNode)
        
        let earthNode = SCNNode()
        let earth = SCNSphere(radius: 1.5)
        earth.firstMaterial?.diffuse.contents = UIImage(named:
            "earth-diffuse-mini.jpg")
        earthNode.geometry = earth
        earthNode.position = SCNVector3(0, 0, 0)
        earthGroupNode.addChildNode(earthNode)
        
        let moonRotationNode = SCNNode()
        earthGroupNode.addChildNode(moonRotationNode)
        
        let moonNode = SCNNode()
        let moon = SCNSphere(radius: 0.75)
        moon.firstMaterial?.diffuse.contents = UIImage(named:"moon.jpg")
        moonNode.geometry = moon
        moonNode.position = SCNVector3Make(5, 0, 0);
        moonRotationNode.addChildNode(moonNode)
        
        let sunHalo = SCNPlane(width: 30, height: 30)
        sunHalo.firstMaterial?.diffuse.contents = UIImage(named: "sun-halo.png")
        sunHalo.firstMaterial?.emission.contents = UIImage(named: "sun-halo.png")
        sunHalo.firstMaterial?.lightingModel = .constant
        sunHalo.firstMaterial?.writesToDepthBuffer = false
        
        let sunHaloNode = SCNNode()
        sunHaloNode.opacity = 0.4;
        sunHaloNode.constraints = [SCNBillboardConstraint()]
        sunHaloNode.geometry = sunHalo
        
        sunNode.addChildNode(sunHaloNode)
        
        earthRotationNode.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, 
                                   duration: 10)
            )
        )
        
        earthNode.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, 
                                   duration: 1)
            )
        )
        
        moonRotationNode.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, 
                                   duration: 1.5)
            )
        )
        
        moonNode.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, 
                                   duration: 1.5)
            )
        )
        
        scnView = ARSCNView()
        self.view.addSubview(scnView)
        
        scnView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: 
            "V:|[scnView]|", options: NSLayoutFormatOptions(rawValue: 0), 
                             metrics: nil, views: ["scnView": scnView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: 
            "H:|[scnView]|", options: NSLayoutFormatOptions(rawValue: 0), 
                             metrics: nil, views: ["scnView": scnView]))    
        
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        scnView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        scnView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {}
    func sessionWasInterrupted(_ session: ARSession) {}
    func sessionInterruptionEnded(_ session: ARSession) {}
}

PlaygroundPage.current.liveView = GameViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
