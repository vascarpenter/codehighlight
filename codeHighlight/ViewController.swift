//
//  ViewController.swift
//  codeHighlight
//
//  Created by Namikare Gikoha on 2020/04/07.
//  Copyright © 2020 gikoha. All rights reserved.
//
// install highlight command using "brew install highlight" first!
// this program assumes highlight is in "/usr/local/bin"

import Cocoa

class ViewController: NSViewController {
	@IBOutlet var srcTextView: NSTextView!
	@IBOutlet var dstTextView: NSTextView!
	@IBOutlet weak var swiftButton: NSButton!
	@IBOutlet weak var objcButton: NSButton!
	@IBOutlet weak var csButton: NSButton!
	@IBOutlet weak var golangButton: NSButton!
	@IBOutlet weak var javaButton: NSButton!
	@IBOutlet weak var kotlinButton: NSButton!
	@IBOutlet weak var perlButton: NSButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	// launchを使うのでsandboxを切ることを忘れないように
	private func execute(command: String, arguments: [String] = []) -> String? {
		   let process = Process()
		   process.launchPath = command
		   process.arguments = arguments
		   
		   let pipe = Pipe()
		   process.standardOutput = pipe
		   process.launch()
		   
		   let data = pipe.fileHandleForReading.readDataToEndOfFile()
		   let output = String(data: data, encoding: String.Encoding.utf8)
		   return output
	   }
	
	@IBAction func radioPushed(_ sender: Any) {
	}
	@IBAction func pushButton(_ sender: Any) {

		guard let str = srcTextView.textStorage?.string else { return  }

		let filename = FileManager.default.temporaryDirectory.appendingPathComponent("output.txt")

		do
		{
			try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
		} catch {
			return
		}
		
		var syntax = "swift"
		if objcButton.selectedTag()==1 { syntax="objc" }
		else if csButton.selectedTag()==1 { syntax="csharp"}
		else if golangButton.selectedTag()==1 { syntax="go" }
		else if javaButton.selectedTag()==1 { syntax="java" }
		else if kotlinButton.selectedTag()==1 { syntax="kotlin" }
		else if perlButton.selectedTag()==1 { syntax="perl" }

		guard let dst = execute(command: "/usr/local/bin/highlight",
								arguments: ["--syntax",syntax,
								 "-O","html","--inline-css",
								 "-K","8","--font=Menlo",
								 "--enclose-pre",
								 "--style=github",
								 filename.path]) else { return }

		dstTextView.textStorage?.setAttributedString(NSMutableAttributedString(string: dst))
	}
	
}

