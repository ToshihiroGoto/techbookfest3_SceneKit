import PlaygroundSupport
import UIKit
import SceneKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        
        let videoW = 720.0
        let videoH = 404.0
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        cameraNode.camera?.vignettingPower
        cameraNode.camera?.vignettingIntensity
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // AVPlayer の設定
        let item = AVPlayerItem(url: URL(fileURLWithPath: Bundle.main.path(forResource: "movie", ofType: "mov")!))
        let videoPlayer = AVPlayer(playerItem: item)
        
        videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none;
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.stateEnd),
                                               name: NSNotification.Name("AVPlayerItemDidPlayToEndTimeNotification"),
                                               object: videoPlayer.currentItem)
        
        videoPlayer.play()
        
        // SKScene の設定
        let skScene = SKScene()
        skScene.backgroundColor = UIColor.black
        skScene.size = CGSize(width: videoW, height: videoH)
        
        let skVideoNode = SKVideoNode(avPlayer: videoPlayer)
        skVideoNode.size = CGSize(width: videoW, height: videoH)
        skVideoNode.position = CGPoint(x: videoW / 2, y: videoH / 2)
        skVideoNode.yScale = -1.0
        skScene.addChild(skVideoNode)
        
        // SCNPlane の設定
        let planeNode = SCNNode(geometry: SCNPlane(width: CGFloat(videoW/100), height: CGFloat(videoH/100)))
        planeNode.geometry?.firstMaterial?.diffuse.contents = skScene
        planeNode.position = SCNVector3(0, 0, -12)
        scene.rootNode.addChildNode(planeNode)
        
        // View 設定
        let scnView = SCNView()
        self.view.addSubview(scnView)
        
        // View の Autolayout
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
    
    @objc func stateEnd(notification: NSNotification) {
        let avPlayerItem = notification.object as? AVPlayerItem
        avPlayerItem?.seek(to: kCMTimeZero, completionHandler: nil)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}

PlaygroundPage.current.liveView = GameViewController()
