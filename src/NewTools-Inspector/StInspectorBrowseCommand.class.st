Class {
	#name : #StInspectorBrowseCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Inspector-Command'
}

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
		name: 'Browse';
		description: 'Browse instance class.'
]

{ #category : #accessing }
StInspectorBrowseCommand >> model [
	^ self owner presenter
]

{ #category : #accessing }
StInspectorBrowseCommand >> owner [ 
	
	^ context owner
]
