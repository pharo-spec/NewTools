"
Command to spawn a browser opened on the selected result item.
"
Class {
	#name : 'StFinderBrowseCommand',
	#superclass : 'StFinderCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'default' }
StFinderBrowseCommand class >> defaultDescription [

	^ 'Browse selection'
]

{ #category : 'initialization' }
StFinderBrowseCommand class >> defaultIconName [

	^ #smallHierarchyBrowser
]

{ #category : 'default' }
StFinderBrowseCommand class >> defaultName [

	^ 'Browse'
]

{ #category : 'initialization' }
StFinderBrowseCommand class >> defaultShortcut [

	^ $b meta
]

{ #category : 'testing' }
StFinderBrowseCommand >> canBeExecuted [ 

	^ super canBeExecuted and: [ 
		self resultTree selectedItems size = 1
			and: [ self selectedItem isClassResult ] ]
]

{ #category : 'executing' }
StFinderBrowseCommand >> execute [
	"Browse the selection"

	self selectedItem browseAction

]
