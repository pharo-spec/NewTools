Class {
	#name : #StInspectorBrowseCommand,
	#superclass : #LtCommand,
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

{ #category : #execution }
StInspectorBrowseCommand >> execute [ 

	self model inspectedObject browse
]

{ #category : #initialization }
StInspectorBrowseCommand >> initialize [ 
	
	super initialize.
	self 
		addGroup: StInspectorCommandGroup uniqueInstance;
		name: 'Browse';
		description: 'Browse instance class.';
		iconName: #smallSystemBrowser
]

{ #category : #accessing }
StInspectorBrowseCommand >> model [
	^ self owner presenter
]

{ #category : #accessing }
StInspectorBrowseCommand >> owner [ 
	
	^ context owner
]
