//
//  NoteCell.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 10.05.2021.
//

import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var ImageNote: UIImageView!
    @IBOutlet weak var labelLocation: UILabel!
    
    @IBOutlet weak var labelDateUpdate: UILabel!
    @IBOutlet weak var labelNameNote: UILabel!
    
    var note:Note?
    
    func initCell (note: Note){
        self.note = note
        if note.imageSmall != nil {
            ImageNote.image = UIImage(data: note.imageSmall as! Data)
        } else {
            //ImageNote.image = nil   ImageNote это наш отутлет со сцены
            ImageNote.image = UIImage(named: "noteImage.png")
            
        }
        
        ImageNote.layer.cornerRadius = ImageNote.frame.width/2
        ImageNote.layer.masksToBounds = true
        
        labelNameNote.text = note.name
        labelDateUpdate.text = note.dateUpdateString
        
        if let _ = note.location{
            labelLocation.text = "Location"
        } else {
            labelLocation.text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
