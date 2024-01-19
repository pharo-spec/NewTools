Class {
	#name : 'StFinderSendersCommand',
	#superclass : 'StFinderCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'default' }
StFinderSendersCommand class >> defaultDescription [

	^ 'Browse selection senders'
]

{ #category : 'initialization' }
StFinderSendersCommand class >> defaultIconName [

	^ #smallFind
]

{ #category : 'default' }
StFinderSendersCommand class >> defaultName [

	^ 'Senders'
]

{ #category : 'initialization' }
StFinderSendersCommand class >> defaultShortcut [

	^ $n meta
]

{ #category : 'testing' }
StFinderSendersCommand >> canBeExecuted [ 

	^ self resultTree selectedItems size = 1
		and: [ self selectedItem isSelectorResult ]
]

{ #category : 'executing' }
StFinderSendersCommand >> execute [
	"Browse the selection senders"

	self selectedItem sendersAction.

]
