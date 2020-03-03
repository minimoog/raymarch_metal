//
//  ViewController.swift
//  raymarch_metal
//
//  Created by Antonie Jovanoski on 3/4/20.
//  Copyright © 2020 Antonie Jovanoski. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController, MTKViewDelegate {
    var commandQueue: MTLCommandQueue? = nil
    var startTime: Double = CACurrentMediaTime()
    
    @IBOutlet weak var mtkView: MTKView! {
        didSet {
            mtkView.delegate = self
            mtkView.preferredFramesPerSecond = 60
            mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mtkView.device = MTLCreateSystemDefaultDevice()
        commandQueue = mtkView.device?.makeCommandQueue()
        
    }

    func loadShader() -> MTLComputePipelineState? {
        let library = mtkView.device?.makeDefaultLibrary()
        
        if let computeShader = library?.makeFunction(name: "compute") {
            return try? mtkView.device?.makeComputePipelineState(function: computeShader)
        }
        
        return nil
    }
    
    func draw(in view: MTKView) {
        let currentTime = CACurrentMediaTime()
        let offsetTime = currentTime - startTime
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}

