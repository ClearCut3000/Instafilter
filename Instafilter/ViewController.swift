//
//  ViewController.swift
//  Instafilter
//
//  Created by Николай Никитин on 31.12.2021.
//

import UIKit

class ViewController: UIViewController {

  //MARK: - Properties
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var intensity: UISlider!

  //MARK: - ViewController lificycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }


  //MARK: Actions
  @IBAction func intensityChanged(_ sender: Any) {
  }

  @IBAction func changeFilter(_ sender: Any) {
  }

  @IBAction func save(_ sender: Any) {
  }

}

