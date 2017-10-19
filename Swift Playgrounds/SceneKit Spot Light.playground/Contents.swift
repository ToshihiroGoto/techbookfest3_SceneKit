import PlaygroundSupport
import SceneKit

class GameViewController: UIViewController {
    
    var scnView:SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // シーンファイルの呼び出し
        let scene = SCNScene(named: "ship.scn")!
        
        // カメラ
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 2.325, y: 1.414, z: 2.399)
        cameraNode.eulerAngles = SCNVector3(x: -0.125 * Float.pi, y: 0.25 * Float.pi, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        let shipMesh = scene.rootNode.childNode(withName: "shipMesh", recursively: true)!
        
        shipMesh.position = SCNVector3(10,0,0)
        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: -2, z: 0, duration: 1)))

        let spotLight = SCNNode()
        spotLight.light = SCNLight()
        spotLight.light?.type = .spot
        spotLight.light?.intensity = 500
        spotLight.light?.spotOuterAngle = 20
        spotLight.light?.attenuationFalloffExponent = 2
        spotLight.light?.shadowRadius = 4
        spotLight.light?.shadowSampleCount = 10
        spotLight.light?.castsShadow = true
        spotLight.position = SCNVector3(x: 0, y: 10, z: 0)
        spotLight.eulerAngles = SCNVector3(-0.5 * Float.pi, 0 ,0)
        
        // スポットライトが宇宙船を追うコンストレイント
        let constraint = SCNLookAtConstraint(target: shipMesh)
        spotLight.constraints = [constraint]
        
        scene.rootNode.addChildNode(spotLight)
        
        // View 設定
        scnView = SCNView()
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
    }

}

PlaygroundPage.current.liveView = GameViewController()
