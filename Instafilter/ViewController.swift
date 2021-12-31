//
//  ViewController.swift
//  Instafilter
//
//  Created by Николай Никитин on 31.12.2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  //MARK: - Properties
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var intensity: UISlider!
  var currentImage: UIImage!

  //MARK: - ViewController lificycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Instafilter"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
  }

  //MARK: - Methods

  func importPicture(){
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    dismiss(animated: true)
    currentImage = image
  }

  //MARK: Actions
  @IBAction func intensityChanged(_ sender: Any) {
  }

  @IBAction func changeFilter(_ sender: Any) {
  }

  @IBAction func save(_ sender: Any) {
  }

}

