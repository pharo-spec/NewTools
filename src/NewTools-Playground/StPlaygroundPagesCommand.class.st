Class {
	#name : #StPlaygroundPagesCommand,
	#superclass : #LtCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #accessing }
StPlaygroundPagesCommand class >> activations [

	^ { self toolBarActivation }
]

{ #category : #accessing }
StPlaygroundPagesCommand class >> toolBarActivation [

	^ LtToolBarActivation new 
		order: 30;
		yourself
]

{ #category : #execution }
StPlaygroundPagesCommand >> execute [ 

	self inform: #TODO.
]

{ #category : #initialization }
StPlaygroundPagesCommand >> initialize [ 
	
	super initialize.
	self 
		addGroup: StPlaygroundCommandGroup uniqueInstance;
		name: 'Pages';
		description: 'Load a saved page.';
		iconName: #glamorousMore
]
