Class {
	#name : 'StFinderCopySelectionCommand',
	#superclass : 'StFinderCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'default' }
StFinderCopySelectionCommand class >> defaultDescription [

	^ 'Copy the selected results'
]

{ #category : 'initialization' }
StFinderCopySelectionCommand class >> defaultIconName [

	^ #smallCopy
]

{ #category : 'default' }
StFinderCopySelectionCommand class >> defaultName [ 

	^ 'Copy selection'
]

{ #category : 'initialization' }
StFinderCopySelectionCommand class >> defaultShortcut [

	^ $f meta, $c meta
]

{ #category : 'executing' }
StFinderCopySelectionCommand >> execute [
	"Copy the selected finder results to the clipboard"

	| selectorsText |
	selectorsText := String streamContents: [ : stream | 
		self selectedItems do: [ : r |
			r copyTo: stream.
			stream cr ] ].
	Clipboard 
		clipboardText: selectorsText 
		informing: self selectedItems size asString , ' selectors copied to the Clipboard'
]
