Class {
	#name : #StInspectorBrowseCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Inspector-Command'
}

{ #category : #accessing }
StInspectorBrowseCommand class >> activations [

	^ { self toolBarActivation }
]

{ #category : #accessing }
StInspectorBrowseCommand class >> toolBarActivation [

	^ LtToolBarActivation new 
		order: 10;
		yourself
]

{ #category : #converting }
StInspectorBrowseCommand >> asSpecCommand [

	^ super asSpecCommand 
		iconName: #smallSystemBrowser;
		yourself
]

{ #category : #execution }
StInspectorBrowseCommand >> execute [ 

	self model inspectedObject browse
]

{ #category : #initialization }
StInspectorBrowseCommand >> initialize [ 
	
	super initialize.
	self 
		basicName: 'Browse';
		basicDescription: 'Browse instance class.'
]

{ #category : #accessing }
StInspectorBrowseCommand >> model [
	^ self owner presenter
]

{ #category : #accessing }
StInspectorBrowseCommand >> owner [ 
	
	^ context owner
]
