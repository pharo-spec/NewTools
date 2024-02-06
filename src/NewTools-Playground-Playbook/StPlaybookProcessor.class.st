"
A spotter processor to show playbook pages (and being able to pick them there)
"
Class {
	#name : #StPlaybookProcessor,
	#superclass : #StCollectionBasedProcessor,
	#category : #'NewTools-Playground-Playbook-Processor'
}

{ #category : #'default-settings' }
StPlaybookProcessor class >> defaultEnabled [

	^ true
]

{ #category : #accessing }
StPlaybookProcessor class >> order [
	
	^ 10
]

{ #category : #accessing }
StPlaybookProcessor class >> title [
	
	^ 'Playbook Pages'
]

{ #category : #filtering }
StPlaybookProcessor >> collection [

	^ StPlaybook allInstances flatCollect: [ :eachBook | 
		eachBook pages collect: [ :each | 
			StPlaybookPageEntry newPlaybook: eachBook page: each ] ]
]

{ #category : #filtering }
StPlaybookProcessor >> newEntryOn: anElement [

	^ anElement
]

{ #category : #configuration }
StPlaybookProcessor >> showForEmptyQuery [

	^ true
]
