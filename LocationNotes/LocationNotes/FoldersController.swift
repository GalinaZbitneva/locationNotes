//
//  FoldersController.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 19.04.2021.
//

import UIKit

class FoldersController: UITableViewController {

    @IBAction func pushAddAction(_ sender: Any) {
        //стиль всплывающего сообщения с полем для ввода
        let alertController = UIAlertController(title: "Create new folder".localize(), message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField {(text) in
            text.placeholder = "Folder name".localize()
        }
        // добавляем кнопку адд и функцию к ней
        let alertActionAdd = UIAlertAction(title: "Create".localize(), style: UIAlertAction.Style.default) {(alert) in
            let folderName = alertController.textFields?[0].text// тк поле для ввода только одно, а текст филд это массив даннах, то соответсвенно введенный в поле текст будет  иметь индекс [0]
            if folderName != "" {
                _ = Folder.newFolder(name: folderName!.uppercased())//  обман программы, чтобы не создавать отдельную переменную для объекта
                CoreDataManager.sharedInstance.saveContext()// сохранение вновь созданных папок
                self.tableView.reloadData()// обновление внешнего выда таблицы с папками
            }
        }
        let alertActionCancel = UIAlertAction(title: "Cancel".localize(), style: UIAlertAction.Style.cancel){ (alert) in // при нажатии отмены никакой блок кода не выполняется
        }
        alertController.addAction(alertActionAdd)
        alertController.addAction(alertActionCancel)
        present(alertController, animated: true, completion: nil)
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.requestAutorization() // в этом месте при загрузке страницы с папками происходит запрос разрешения о геолокации

        LocationManager.sharedInstance.getCurrentLocation {(location) in print (location)}
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
        return folders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell Folder", for: indexPath)

        let folderInCell = folders[indexPath.row]
        cell.textLabel?.text = folderInCell.name
        cell.detailTextLabel?.text = "\(folderInCell.notes!.count) item(s)".localize()

        return cell
    }
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let folderInCell = folders[indexPath.row]
            CoreDataManager.sharedInstance.managedObjectContext.delete(folderInCell)
            CoreDataManager.sharedInstance.saveContext()// сохраняем изменения
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToOneFolder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOneFolder" {
            let selectedFolder = folders[tableView.indexPathForSelectedRow!.row]
            (segue.destination as! OneFolderController).folder = selectedFolder
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
