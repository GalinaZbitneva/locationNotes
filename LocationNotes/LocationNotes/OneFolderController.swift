//
//  OneFolderController.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 20.04.2021.
//

import UIKit

class OneFolderController: UITableViewController {

    var folder: Folder?
    var notesAll: [Note]{
        if let folder = folder{
            return folder.notesSorted
        } else {
            return notes
        }
    }
    
    var selectedNote: Note?
    
   var buyingForm = BuyingForm()
    
    @IBAction func pushAddNote(_ sender: Any) {
        
        if buyingForm.isNeedToShow {
            buyingForm.showForm(inController: self)
            return
        }
        selectedNote = Note.newNote(name: "Note name".localize(), inFolder: folder)
    
        performSegue(withIdentifier: "goToNameOfNote", sender: self)
        selectedNote?.addCurentLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNameOfNote" {
            (segue.destination as! NameOfNoteController).note = selectedNote
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteInCell = notesAll[indexPath.row]
        selectedNote = noteInCell
        performSegue(withIdentifier: "goToNameOfNote", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let folder = folder {
            navigationItem.title = folder.name
        } else {
            navigationItem.title = "All notes".localize()
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesAll.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNote", for: indexPath) as! NoteCell
        let noteInCell = notesAll[indexPath.row]
        
        cell.initCell(note: noteInCell) // данные в ячейке будут такими как мы обозначили в конроллере ячеек NoteCell
        
        //cell.textLabel?.text = noteInCell.name
        //cell.detailTextLabel?.text = noteInCell.dateUpdateString
        
        //if noteInCell.imageSmall != nil {
         //   cell.imageView?.image = UIImage(data: noteInCell.imageSmall! as Data)
        //} else {
          //  cell.imageView?.image = nil
        //}

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteInCell = notesAll[indexPath.row]
            CoreDataManager.sharedInstance.managedObjectContext.delete(noteInCell)
            CoreDataManager.sharedInstance.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
