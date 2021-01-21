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
StSendersProcessor >> installKeymappingsOn: aGTSpotterMorph [

	aGTSpotterMorph
		bindKeyCombination: $n meta
		ofProcessor: self
		toAction: [ aGTSpotterMorph onKeyProcessor: self ]
]

{ #category : #filtering }
StSendersProcessor >> newTextFilteringSource [

	^ StSendersIterator new 
]
