//
//  PDFViewController.swift
//  iOS_012_File
//
//  Created by DREAMWORLD on 04/03/24.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    var pdfFileURL: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = pdfFileURL.lastPathComponent
        navigationController?.navigationBar.prefersLargeTitles = false

        let pdfView = PDFView()
        pdfView.frame = self.view.frame
        pdfView.autoScales = true
        
        if let document = PDFDocument(url: pdfFileURL) {
            pdfView.document = document
        }
        
        self.view.addSubview(pdfView)
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
