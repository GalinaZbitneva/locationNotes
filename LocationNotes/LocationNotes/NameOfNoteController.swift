//
//  NameOfNoteController.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 21.04.2021.
//

import UIKit

class NameOfNoteController: UITableViewController {

    var note: Note?
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    @IBOutlet weak var labelFolderName: UILabel!
    @IBOutlet weak var labelFolder: UILabel!
    @IBAction func pushDoneAction(_ sender: Any) {
        saveNote()
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    
    @IBOutlet weak var textDescription: UITextView!
    
    
    @IBAction func pushShareAction(_ sender: Any) {
        var activities:[Any] = []
        if let image = note?.imageActual{ // если у заметки есть картинка то в массив добавляем картинку
            activities.append(image)
        }
        activities.append(note?.textDescription ?? "")
        activities.append(note?.name ?? "")
        
        let activityController  = UIActivityViewController(activityItems: activities, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textName.text = note?.name
        textDescription.text = note?.textDescription
        ImageView.image = note?.imageActual
        navigationItem.title = note?.name
        ImageView.layer.cornerRadius = ImageView.frame.width/2
        ImageView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let folder = note?.folder { //если у заметки есть папка
            labelFolderName.text = folder.name
        } else {
            labelFolderName.text = "-"
        }
    }
    
    func saveNote() {
        
        if textName.text == "" && textDescription.text == "" && ImageView.image == nil {
            CoreDataManager.sharedInstance.managedObjectContext.delete(note!
            )
            CoreDataManager.sharedInstance.saveContext()
            return
        }
        if note?.name != textName.text || note?.textDescription != textDescription.text {
            note?.dateUpdate = NSDate() as Date
        }
        
        note?.name = textName.text
        note?.textDescription = textDescription.text
        note?.imageActual = ImageView.image
        
        CoreDataManager.sharedInstance.saveContext()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true) // чтобы снять выделение с ячейки
        
        if indexPath.row == 0 && indexPath.section == 0 {
            let alertController = UIAlertController(title: "Add image".localize(), message: "Would you like to add a photo?".localize(), preferredStyle: UIAlertController.Style.actionSheet)
            
            let case1Camera = UIAlertAction(title: "Make a photo".localize(), style: UIAlertAction.Style.default, handler: { (alert) in
                //print ("shooting")
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            })
            let case2Photo = UIAlertAction(title: "Take a photo from library".localize(), style: UIAlertAction.Style.default, handler: { (alert) in
                //print ("go to library")
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            })
            
            // сделаем так чтобы удаление появлялось только тогдаБ когда уже есть какая-то картинка
            
            if self.ImageView.image != nil{
                let case3Delete = UIAlertAction(title: "Delete image".localize(), style: UIAlertAction.Style.destructive, handler: { (alert) in self.ImageView.image = nil
            })
                alertController.addAction(case3Delete)
            }
            let case4Cancel = UIAlertAction(title: "Cancel".localize(), style: UIAlertAction.Style.cancel, handler: { (alert) in
            })
            
            alertController.addAction(case1Camera)
            alertController.addAction(case2Photo)
            
            alertController.addAction(case4Cancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectedFolder" {
            (segue.destination as! SelectedFolderController).note = note
        }
        
        if segue.identifier == "goToMap" {
            (segue.destination as! NoteMapController).note = note
        }
     
     
        
    }
    

}
extension NameOfNoteController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
