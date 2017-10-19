import MapKit
import PlaygroundSupport

// 現在位置とピン（アノテーション）の場所を設定
let locationUDX = CLLocationCoordinate2DMake(35.700523,139.7725065)

// 地図（MKMapView）を設定
let mapView = MKMapView(frame: UIScreen.main.bounds)

// 現在位置の設定
var mapRegion = MKCoordinateRegion()
let mapRegionSpan = 0.005
mapRegion.center = locationUDX
mapRegion.span.latitudeDelta = mapRegionSpan
mapRegion.span.longitudeDelta = mapRegionSpan

// 現在位置を地図に適応
mapView.setRegion(mapRegion, animated: true)

// ピンを設定する
let annotation = MKPointAnnotation()
annotation.coordinate = locationUDX
annotation.title = "技術書典3"
annotation.subtitle = "秋葉原 / アキバ・スクエア"

// ピンを地図に立てる
mapView.addAnnotation(annotation)

// Playground Live View に地図を適応して表示
PlaygroundPage.current.liveView = mapView




