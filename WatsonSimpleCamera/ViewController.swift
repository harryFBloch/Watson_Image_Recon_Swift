//
//  ViewController.swift
//  WatsonSimpleCamera
//
//  Created by harry bloch on 6/4/17.
//  Copyright © 2017 harry bloch. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import AlamofireImage


class ViewController: UIViewController {
    
    let apiKey = "3c9985cb1539c238965371ae2499ca9471c36f04"
    let version = "2017-6-1"

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func getImage(_ sender: Any) {
        let button = sender as! UIBarButtonItem
        button.isEnabled = false
        let randomNumber = Int(arc4random_uniform(1000))
        
        let url = URL(string:"https://unsplash.it/400/700?image=\(randomNumber)")!
        imageView.af_setImage(withURL: url);
        
        let visualReconigition = VisualRecognition(apiKey: apiKey, version: version)
        let failure = {(error:Error) in
            DispatchQueue.main.async {
                print("Fail")
                self.navigationItem.title = "Image could not be processed"
                button.isEnabled = true
            }
            print(error)
        }
        let recogURL = URL(string:"https://unsplash.it/50/100?image=\(randomNumber)")!
        visualReconigition.classify(image: recogURL.absoluteString, failure: failure) { classifiedImages in
            
            if let classifiedImage = classifiedImages.images.first {
                print(classifiedImage.classifiers)
                
                if let classification = classifiedImage.classifiers.first?.classes.first?.classification {
                    DispatchQueue.main.async {
                        self.navigationItem.title = classification
                        button.isEnabled = true
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    self.navigationItem.title = "Could not be Determined"
                    button.isEnabled = true
                }
            }
            
        }
    }
}

