"
Command to spawn a browser of Implementors on the selected result item in the Finder tool.

"
Class {
	#name : 'StFinderImplementorsCommand',
	#superclass : 'StFinderCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'default' }
StFinderImplementorsCommand class >> defaultDescription [

	^ 'Browse selection implementors'
]

{ #category : 'initialization' }
StFinderImplementorsCommand class >> defaultIconName [

	^ #browse
]

{ #category : 'default' }
StFinderImplementorsCommand class >> defaultName [

	^ 'Implementors'
]

{ #category : 'initialization' }
StFinderImplementorsCommand class >> defaultShortcut [

	^ $m meta
]

{ #category : 'testing' }
StFinderImplementorsCommand >> canBeExecuted [ 

	^ self resultTree selectedItems size = 1
		and: [ self selectedItem isSelectorResult ]
]

{ #category : 'executing' }
StFinderImplementorsCommand >> execute [
	"Browse the selection implementors"

	self selectedItem implementersAction

]
