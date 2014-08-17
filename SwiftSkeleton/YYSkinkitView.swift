

import UIKit
import QuartzCore
enum YYSpinKitViewStyle {
    case Plane
    case Bounce
    case Wave
    case WanderingCubes
    case Pulse
}

let kYYSpinKitDegToRad:CGFloat = 0.0174532925

class YYSpinkitView: UIView {
    
    var _color:UIColor?
    var color:UIColor?{
        set{
            self._color = newValue
            //        for l:AnyObject in self.layer.sublayers {
            //            var layer = l as CALayer
            //            layer.backgroundColor = self._color!.CGColor
            //        }
        }
        get{
            return self._color
        }
    }
    var hidesWhenStopped:Bool?
    
    var style:YYSpinKitViewStyle?
    
    var stopped:Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    init(style:YYSpinKitViewStyle){
        super.init(frame: CGRectZero)
    }
    
    func spinKit3DRotationWithPerspective(#perspective:Float,angle:CDouble,x:Float,y:Float,z:Float)->CATransform3D{
        var transform:CATransform3D = CATransform3DIdentity
        transform.m34 = CGFloat(perspective)
        return CATransform3DRotate(transform, CGFloat(angle), CGFloat(x), CGFloat(y), CGFloat(z))
    }
    
    init(style:YYSpinKitViewStyle,color:UIColor){
        super.init(frame: CGRectZero)
        self.style = style
        self.color = color
        
        self.sizeToFit()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        
        if self.style == YYSpinKitViewStyle.Plane {
            var plane = CALayer()
            plane.frame = CGRectInset(self.bounds, 2.0, 2.0)
            plane.backgroundColor = color.CGColor
            plane.anchorPoint = CGPointMake(0.5, 0.5)
            plane.anchorPointZ = 0.5
            self.layer.addSublayer(plane)
            
            var anim = CAKeyframeAnimation(keyPath:"transform")
            anim.removedOnCompletion = false
            anim.repeatCount = Float.infinity
            anim.duration = 1.2
            anim.keyTimes = [0.0, 0.5, 1.0]
            
            
            
            anim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            ];
            
            
            anim.values = [
                NSValue(CATransform3D: spinKit3DRotationWithPerspective(perspective:1.0/120.0, angle:0, x:0, y:0, z:0)),
                NSValue(CATransform3D: spinKit3DRotationWithPerspective(perspective:1.0/120.0,angle:M_PI,x: 0.0, y:1.0,z:0.0)),
                NSValue(CATransform3D: spinKit3DRotationWithPerspective(perspective:1.0/120.0, angle:M_PI, x:0.0, y:0.0,z:1.0))]
            
            plane.addAnimation(anim,forKey:"spinkit-anim")
        }
        else if self.style == YYSpinKitViewStyle.Bounce {
            var beginTime = CACurrentMediaTime()
            
            for  var i:Int = 0; i < 2; i+=1 {
                var circle = CALayer()
                circle.frame = CGRectInset(self.bounds, 2.0, 2.0)
                circle.backgroundColor = color.CGColor
                circle.anchorPoint = CGPointMake(0.5, 0.5)
                circle.opacity = 0.6
                circle.cornerRadius = CGRectGetHeight(circle.bounds) * 0.5
                circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
                self.layer.addSublayer(circle)
                
                var anim = CAKeyframeAnimation(keyPath:"transform")
                anim.removedOnCompletion = false
                anim.repeatCount = Float.infinity
                anim.duration = 2.0
                anim.beginTime = beginTime - CFTimeInterval(1.0 * Float(i))
                anim.keyTimes = [0.0, 0.5, 1.0]
                
                
                anim.timingFunctions = [
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                ];
                
                anim.values = [
                    NSValue(CATransform3D: CATransform3DMakeScale(0.0, 0.0, 0.0)),
                    NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 0.0)),
                    NSValue(CATransform3D: CATransform3DMakeScale(0.0, 0.0, 0.0))]
                circle.addAnimation(anim,forKey:"spinkit-anim")
            }
        }
        else if style == YYSpinKitViewStyle.Wave {
            var beginTime = CACurrentMediaTime() + 1.2
            var barWidth = CGRectGetWidth(self.bounds) / 5.0
            
            for var i=0; i < 5; i+=1 {
                var layer = CALayer()
                layer.backgroundColor = color.CGColor
                layer.frame = CGRectMake(barWidth * CGFloat(i), 0.0, barWidth - 3.0, CGRectGetHeight(self.bounds));
                layer.transform = CATransform3DMakeScale(1.0, 0.3, 0.0)
                self.layer.addSublayer(layer)
                
                var anim = CAKeyframeAnimation(keyPath:"transform")
                anim.removedOnCompletion = false
                anim.beginTime = beginTime - NSTimeInterval(1.2 - (0.1 * Float(i)))
                anim.duration = 1.2
                anim.repeatCount = Float.infinity
                
                anim.keyTimes = [0.0, 0.2, 0.4, 1.0]
                
                
                anim.timingFunctions = [
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                ];
                
                anim.values = [
                    NSValue(CATransform3D: CATransform3DMakeScale(1.0, 0.4, 0.0)),
                    NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 0.0)),
                    NSValue(CATransform3D: CATransform3DMakeScale(1.0, 0.4, 0.0)),
                    NSValue(CATransform3D: CATransform3DMakeScale(1.0, 0.4, 0.0))]
                layer.addAnimation(anim,forKey:"spinkit-anim")
            }
        }
        else if style == YYSpinKitViewStyle.WanderingCubes {
            var beginTime = CACurrentMediaTime()
            var cubeSize = floor(CDouble(CGRectGetWidth(self.bounds) / 3.0))
            var widthMinusCubeSize = CGRectGetWidth(self.bounds) - CGFloat(cubeSize)
            
            for var i=0; i<2; i+=1 {
                var cube = CALayer()
                cube.backgroundColor = color.CGColor
                cube.frame = CGRectMake(0.0, 0.0, CGFloat(cubeSize), CGFloat(cubeSize))
                cube.anchorPoint = CGPointMake(0.5, 0.5)
                self.layer.addSublayer(cube)
                
                var anim = CAKeyframeAnimation(keyPath:"transform")
                anim.removedOnCompletion = false
                anim.beginTime = beginTime - NSTimeInterval(Float(i) * 0.9);
                anim.duration = 1.8
                anim.repeatCount = Float.infinity
                
                anim.keyTimes = [0.0,0.25,0.50,0.75,1.0]
                
                
                
                anim.timingFunctions = [
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                ];
                
                
                var t0 = CATransform3DIdentity
                
                var t1 = CATransform3DMakeTranslation(widthMinusCubeSize, 0.0, 0.0)
                t1 = CATransform3DRotate(t1, -90.0 * kYYSpinKitDegToRad, 0.0, 0.0, 1.0)
                t1 = CATransform3DScale(t1, 0.5, 0.5, 1.0)
                
                var t2 = CATransform3DMakeTranslation(widthMinusCubeSize, widthMinusCubeSize, 0.0)
                t2 = CATransform3DRotate(t2, -180.0 * kYYSpinKitDegToRad, 0.0, 0.0, 1.0)
                t2 = CATransform3DScale(t2, 1.0, 1.0, 1.0)
                
                var t3 = CATransform3DMakeTranslation(0.0, widthMinusCubeSize, 0.0)
                t3 = CATransform3DRotate(t3, -270.0 * kYYSpinKitDegToRad, 0.0, 0.0, 1.0)
                t3 = CATransform3DScale(t3, 0.5, 0.5, 1.0)
                
                var t4 = CATransform3DMakeTranslation(0.0, 0.0, 0.0)
                t4 = CATransform3DRotate(t4, -360.0 * kYYSpinKitDegToRad, 0.0, 0.0, 1.0)
                t4 = CATransform3DScale(t4, 1.0, 1.0, 1.0)
                
                
                anim.values = [NSValue(CATransform3D:t0),
                    NSValue(CATransform3D:t1),
                    NSValue(CATransform3D:t2),
                    NSValue(CATransform3D:t3),
                    NSValue(CATransform3D:t4)]
                
                cube.addAnimation(anim,forKey:"spinkit-anim")
            }
        }
        else if style == YYSpinKitViewStyle.Pulse {
            var beginTime = CACurrentMediaTime()
            
            var circle = CALayer()
            circle.frame = CGRectInset(self.bounds, 2.0, 2.0)
            circle.backgroundColor = color.CGColor
            circle.anchorPoint = CGPointMake(0.5, 0.5)
            circle.opacity = 1.0
            circle.cornerRadius = CGRectGetHeight(circle.bounds) * 0.5
            circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            self.layer.addSublayer(circle)
            
            var scaleAnim = CAKeyframeAnimation(keyPath:"transform")
            scaleAnim.values = [
                NSValue(CATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)),
                NSValue(CATransform3D:CATransform3DMakeScale(1.0, 1.0, 0.0))
            ]
            
            var opacityAnim = CAKeyframeAnimation(keyPath:"opacity")
            opacityAnim.values = [1.0,0.0]
            
            var animGroup = CAAnimationGroup()
            animGroup.removedOnCompletion = false
            animGroup.beginTime = beginTime
            animGroup.repeatCount = Float.infinity
            animGroup.duration = 1.0
            animGroup.animations = [scaleAnim, opacityAnim]
            animGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            circle.addAnimation(animGroup,forKey:"spinkit-anim")
        }
    }
    
    func applicationWillEnterForeground(){
        if self.stopped!{
            self.pauseLayers()
        }else{
            self.resumeLayers()
        }
    }
    
    func applicationDidEnterBackground(){
        self.pauseLayers()
    }
    
    func startAnimating(){
        self.hidden = false
        self.stopped = false
        self.resumeLayers()
    }
    
    func stopAnimating(){
        if self.hidesWhenStopped == true {
            self.hidden = true
        }
        
        self.stopped = true
        self.pauseLayers()
    }
    
    func pauseLayers(){
        var pausedTime = self.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        self.layer.speed = 0.0
        self.layer.timeOffset = pausedTime
    }
    
    func resumeLayers(){
        var pausedTime = self.layer.timeOffset
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        self.layer.beginTime = 0.0
        var timeSincePause = self.layer.convertTime(CACurrentMediaTime(),fromLayer:nil) - pausedTime
        self.layer.beginTime = timeSincePause
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(37.0, 37.0)
    }
}
