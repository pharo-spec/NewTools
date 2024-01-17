Class {
	#name : 'StFinderSelectAllCommand',
	#superclass : 'StFinderCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'default' }
StFinderSelectAllCommand class >> defaultDescription [

	^ 'Command to select all result on the Finder settings.'
]

{ #category : 'initialization' }
StFinderSelectAllCommand class >> defaultIconName [

	^ #checkedBox
]

{ #category : 'default' }
StFinderSelectAllCommand class >> defaultName [

	^ 'Select All'
]

{ #category : 'initialization' }
StFinderSelectAllCommand class >> defaultShortcut [

	^ $f meta, $a meta
]

{ #category : 'testing' }
StFinderSelectAllCommand >> canBeExecuted [ 

	^ super canBeExecuted and: [ self selectedItems ~= self resultTreeItems size ]
]

{ #category : 'executing' }
StFinderSelectAllCommand >> execute [
	"Select all result items"

	self context selectedResults: self resultTreeItems.
	self resultTree selectItems: self resultTreeItems.

]
