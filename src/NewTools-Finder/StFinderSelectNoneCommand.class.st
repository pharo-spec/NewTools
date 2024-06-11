Class {
	#name : 'StFinderSelectNoneCommand',
	#superclass : 'StFinderCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'default' }
StFinderSelectNoneCommand class >> defaultDescription [

	^ 'Unselect all results'
]

{ #category : 'initialization' }
StFinderSelectNoneCommand class >> defaultIconName [

	^ #checkboxUnselected
]

{ #category : 'default' }
StFinderSelectNoneCommand class >> defaultName [

	^ 'Select None'
]

{ #category : 'initialization' }
StFinderSelectNoneCommand class >> defaultShortcut [

	^ $f meta, $m meta
]

{ #category : 'testing' }
StFinderSelectNoneCommand >> canBeExecuted [ 

	^ super canBeExecuted and: [ self selectedItems ~= 0 ]
]

{ #category : 'executing' }
StFinderSelectNoneCommand >> execute [
	"Unselect all result items"

	self context selectedResults: Set empty.
	self resultTree unselectAll
]
