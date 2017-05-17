//
//  ViewController.swift
//  EtchASketch
//
//  Created by Shane Lacey on 27/04/2017.
//  Copyright © 2017 Shane Lacey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var knobVerticalHolder: UIView!
    @IBOutlet weak var knobHorizontalHolder: UIView!
    @IBOutlet weak var DrawView: UIImageView!
    @IBOutlet weak var optionView: UIView!
    
    var lastPoint = CGPoint.zero
    var lastVerticalKnobPos: Float = 0
    var lastHorizontalKnobPos: Float = 0
    let xMin: Float = 0
    let yMin: Float = 0
    var xMax: Float = 0
    var yMax: Float = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        xMax = Float(view.frame.size.width)
        yMax = Float(view.frame.size.height)
        optionView.layer.cornerRadius = 10
        showKnob()
    }
    
    func showKnob() {
        let knobVerticalControl = IOSKnobControl(frame: knobVerticalHolder.bounds)
        knobVerticalControl!.mode = .continuous
        knobVerticalControl!.circular = true
        knobVerticalControl!.clockwise = true
        knobVerticalControl!.setFill(UIColor.white, for: .normal)
        knobVerticalControl!.setFill(UIColor.lightGray, for: .highlighted)
        knobVerticalControl!.setTitleColor(UIColor.black, for: .normal)
        knobVerticalControl!.setTitleColor(UIColor.white, for: .highlighted)
        knobVerticalControl!.addTarget(self, action: #selector(knobVerticalChanged), for: .valueChanged)
        knobVerticalHolder.addSubview(knobVerticalControl!)
        
        let knobHorizontalControl = IOSKnobControl(frame: knobHorizontalHolder.bounds)
        knobHorizontalControl!.mode = .continuous
        knobHorizontalControl!.circular = true
        knobHorizontalControl!.clockwise = true
        knobHorizontalControl!.setFill(UIColor.white, for: .normal)
        knobHorizontalControl!.setFill(UIColor.lightGray, for: .highlighted)
        knobHorizontalControl!.setTitleColor(UIColor.black, for: .normal)
        knobHorizontalControl!.setTitleColor(UIColor.white, for: .highlighted)
        knobHorizontalControl!.addTarget(self, action: #selector(knobHorizontalChanged), for: .valueChanged)
        knobHorizontalHolder.addSubview(knobHorizontalControl!)
    }
    
    func knobVerticalChanged(sender: IOSKnobControl) {
        let fromP = CGPoint(x: lastPoint.x, y: lastPoint.y)
        var toP = CGPoint(x: lastPoint.x, y: lastPoint.y)
        if(lastVerticalKnobPos < sender.position){
            if(!(Float(lastPoint.y - 1.5) < yMin)){
                toP.y = lastPoint.y - 1.5
            }
        }
        else if(lastVerticalKnobPos > sender.position){
            if(!(Float(lastPoint.y + 1.5) > yMax)){
                toP.y = lastPoint.y + 1.5
            }
        }
        lastPoint = toP
        lastVerticalKnobPos = sender.position
        drawLine(from: fromP, to: toP)
    }
    
    func knobHorizontalChanged(sender: IOSKnobControl) {
        let fromP = CGPoint(x: lastPoint.x, y: lastPoint.y)
        var toP = CGPoint(x: lastPoint.x, y: lastPoint.y)
        if(lastHorizontalKnobPos < sender.position){
            if(!(Float(lastPoint.x + 1.5) > xMax)) {
                toP.x = lastPoint.x + 1.5
            }
        }
        else if(lastHorizontalKnobPos > sender.position){
            if(!(Float(lastPoint.x - 1.5) < xMin)) {
                toP.x = lastPoint.x - 1.5
            }
        }
        lastPoint = toP
        lastHorizontalKnobPos = sender.position
        drawLine(from: fromP, to: toP)
    }
    
    func drawLine(from: CGPoint, to: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        DrawView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        context!.move(to: CGPoint(x: from.x, y: from.y))
        context!.addLine(to: CGPoint(x: to.x, y: to.y))
        context!.strokePath()
//        print("Drawing:", from.x, from.y, to.x, to.y)
//        print("Frame size:", xMax, yMax)
        
        DrawView.image = UIGraphicsGetImageFromCurrentImageContext()
        DrawView.alpha = 1
        UIGraphicsEndImageContext()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(event?.subtype == UIEventSubtype.motionShake){
            DrawView.image = nil
            optionView.layer.position.x = -305
        }
    }

    @IBAction func showOptionView(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.5, animations: {
            self.optionView.layer.position.x = self.view.bounds.width / 2
            self.knobVerticalHolder.alpha = 0.5
            self.knobHorizontalHolder.alpha = 0.5
            self.DrawView.alpha = 0.5
            self.knobVerticalHolder.isUserInteractionEnabled = false
            self.knobHorizontalHolder.isUserInteractionEnabled = false
        })
    }
    
    @IBAction func hideOptionView(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: {
            self.optionView.layer.position.x = -305
            self.knobVerticalHolder.alpha = 1
            self.knobHorizontalHolder.alpha = 1
            self.DrawView.alpha = 1
            self.knobVerticalHolder.isUserInteractionEnabled = true
            self.knobHorizontalHolder.isUserInteractionEnabled = true
        })
    }
    
    @IBAction func saveDrawing(_ sender: AnyObject) {
        hideOptionView(self)
    }
    
    @IBAction func shareDrawing(_ sender: AnyObject) {
        hideOptionView(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

