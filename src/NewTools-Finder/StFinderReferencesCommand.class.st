Class {
	#name : 'StFinderReferencesCommand',
	#superclass : 'StFinderCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'default' }
StFinderReferencesCommand class >> defaultDescription [

	^ 'Browse references'
]

{ #category : 'initialization' }
StFinderReferencesCommand class >> defaultIconName [

	^ #references
]

{ #category : 'default' }
StFinderReferencesCommand class >> defaultName [

	^ 'References'
]

{ #category : 'initialization' }
StFinderReferencesCommand class >> defaultShortcut [

	^ $r meta
]

{ #category : 'testing' }
StFinderReferencesCommand >> canBeExecuted [ 

	^ self resultTree selectedItems size = 1
		and: [ self selectedItem isClassResult ]
]

{ #category : 'executing' }
StFinderReferencesCommand >> execute [
	"Browse the selection references"

	self selectedItem referencesAction

]
