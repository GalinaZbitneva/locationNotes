//
//  MapController.swift
//  LocationNotes
//
//  Created by Галина Збитнева on 03.05.2021.
//

import UIKit
import MapKit

class MapController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let ltgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
            mapView.gestureRecognizers = [ltgr]
        }


    override func viewWillAppear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        for note in notes {
            if note.locationActual != nil {
                mapView.addAnnotation(NoteAnnotation(note: note)) //отобразили все заметки на карте
            }
        }
    }

    @objc func handleLongTap (recognizer: UIGestureRecognizer) {
    if recognizer.state != .began {
        return
    }
    let point = recognizer.location(in: mapView)
    let c = mapView.convert(point, toCoordinateFrom: mapView)
    
    let newNote = Note.newNote(name: "", inFolder: nil)
    newNote.locationActual = LocationCoordinate(lat: c.latitude, lon: c.longitude)
    let noteController = storyboard?.instantiateViewController(identifier: "noteSID") as! NameOfNoteController
    noteController.note = newNote
    navigationController?.pushViewController(noteController, animated: true)
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            DispatchQueue.main.async {
                mapView.setCenter(annotation.coordinate, animated: true)
            }
            return nil
        }
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure) // эта команда создает окошко с информацией на карте
        return pin
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let selectedNote = (view.annotation as! NoteAnnotation).note
        let noteController = storyboard?.instantiateViewController(identifier: "noteSID") as! NameOfNoteController // здесь мы присвоили пременной свойства контроллера
        noteController.note = selectedNote
       // present(noteController, animated: true, completion: nil)
        navigationController?.pushViewController(noteController, animated: true)
    }
}
