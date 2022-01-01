//
//  ViewController.swift
//  Instafilter
//
//  Created by Николай Никитин on 31.12.2021.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  //MARK: - Properties
  @IBOutlet var imageView: UIImageView!

  @IBOutlet var intensity: UISlider!
  @IBOutlet var radius: UISlider!
  @IBOutlet var scale: UISlider!

  @IBOutlet var filterButton: UIButton!

  var currentImage: UIImage!
  var context: CIContext!
  var currentFilter: CIFilter!

  //MARK: - ViewController lificycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Instafilter"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone")
  }

  //MARK: - Methods

  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }

  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      let alert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default))
      present(alert, animated: true)
    } else {
      let alert = UIAlertController(title: "Image saved", message: "Your image has been successfully saved to the photo library.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default))
      present(alert, animated: true)
    }
  }

  func setFilter(action: UIAlertAction) {
    guard currentImage != nil else { return }
    guard let actionTitle = action.title else { return }
    currentFilter = CIFilter(name: actionTitle)
    filterButton.setTitle(actionTitle , for: .normal)

    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    applyProcessing()
  }

  func applyProcessing(){
    let inputKeys = currentFilter.inputKeys
    if inputKeys.contains(kCIInputIntensityKey) {
      intensity.isEnabled = true
      intensity.value = 0.5
      currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
    } else {
      intensity.isEnabled = false
      intensity.value = 0
    }

    if inputKeys.contains(kCIInputRadiusKey) {
      radius.isEnabled = true
      radius.value = 0.5
      currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
    } else {
      radius.isEnabled = false
      radius.value = 0
    }

    if inputKeys.contains(kCIInputScaleKey) {
      scale.isEnabled = true
      scale.value = 0.5
      currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey)
    } else {
      scale.isEnabled = false
      scale.value = 0
    }

    if inputKeys.contains(kCIInputCenterKey) {
      currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
    }

    guard let outputImage = currentFilter.outputImage else { return }
    if let cgImage = context.createCGImage( outputImage, from: outputImage.extent) {
      let processedImage = UIImage(cgImage: cgImage)
      self.imageView.image = processedImage
    }
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    dismiss(animated: true)
    currentImage = image
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    applyProcessing()
  }

  //MARK: - Actions
  @IBAction func intensityChanged(_ sender: Any) {
    applyProcessing()
  }

  @IBAction func changeFilter(_ sender: UIButton) {
    let alert = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
    alert.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
    alert.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
    alert.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
    alert.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
    alert.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
    alert.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    //For iPads - popoverPresentationController will apper from button
    if let popoverController = alert.popoverPresentationController{
      popoverController.sourceView = sender
      popoverController.sourceRect = sender.bounds
    }
    present(alert, animated: true)
  }

  @IBAction func save(_ sender: Any) {
    if let image = imageView.image {
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    } else {
      let alert = UIAlertController(title: "The image is not selected!", message: "First you need to select an image from the library by clicking the plus sign in the upper right corner of the screen.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default))
      present(alert, animated: true)
    }
  }

}

