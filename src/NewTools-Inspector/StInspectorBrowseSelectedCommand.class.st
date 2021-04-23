"
Browse current selected object.
"
Class {
	#name : #StInspectorBrowseSelectedCommand,
	#superclass : #StInspectorCommand,
	#category : #'NewTools-Inspector-Command'
}

{ #category : #documentation }
StInspectorBrowseSelectedCommand class >> documentContextRequiredSelectors [

	^ super documentContextRequiredSelectors, #(selectedObject)
]

{ #category : #converting }
StInspectorBrowseSelectedCommand >> asSpecCommand [

	^ super asSpecCommand 
		iconName: #smallSystemBrowser;
		yourself
]

{ #category : #execution }
StInspectorBrowseSelectedCommand >> execute [ 

	self interestingObject browse
]

{ #category : #execution }
StInspectorBrowseSelectedCommand >> interestingObject [

	^ self context selectedObject
]
