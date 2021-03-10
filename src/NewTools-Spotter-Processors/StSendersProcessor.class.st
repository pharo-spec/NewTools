"
I implement the lookup of #Senders and the Meta + n binding.

"
Class {
	#name : #StSendersProcessor,
	#superclass : #StSpotterProcessor,
	#category : #'NewTools-Spotter-Processors-Processors'
}

{ #category : #'default-settings' }
StSendersProcessor class >> defaultEnabled [

	^ true
]

{ #category : #accessing }
StSendersProcessor class >> order [
	
	^ 15
]

{ #category : #accessing }
StSendersProcessor class >> title [
	
	^ 'Senders'
]

{ #category : #filtering }
StSendersProcessor >> executeQuery [

	(query categoriesSelected includes: 'Senders')
		ifFalse: [ ^ self ].

	^ super executeQuery 
]

{ #category : #'key-bindings' }
StSendersProcessor >> installKeymappingsOn: aPresenter onExecution: aBlock [

	aPresenter
		bindKeyCombination: $n meta
		toAction: [ 
			aPresenter onKeyProcessor: self.
			aBlock cull: self ]
]

{ #category : #filtering }
StSendersProcessor >> newTextFilteringSource [

	^ StSendersIterator new 
]
