"
I am a processor that shows all the entries in the spotter history.
"
Class {
	#name : #StHistoryProcessor,
	#superclass : #StCollectionBasedProcessor,
	#category : #'NewTools-Spotter-Processors-Processors'
}

{ #category : #'default-settings' }
StHistoryProcessor class >> defaultEnabled [

	^ true
]

{ #category : #accessing }
StHistoryProcessor class >> order [
	
	^ 8
]

{ #category : #accessing }
StHistoryProcessor class >> title [

	^ 'History'
]

{ #category : #filtering }
StHistoryProcessor >> collection [

	^ GTSpotter history reject: [ :e | e isNil ]
]

{ #category : #filtering }
StHistoryProcessor >> newEntryOn: anElement [

	^ anElement
]

{ #category : #configuration }
StHistoryProcessor >> showForEmptyQuery [

	^ true
]
