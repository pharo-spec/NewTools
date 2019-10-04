Class {
	#name : #StPlaygroundPagesCommand,
	#superclass : #StPlaygroundCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #converting }
StPlaygroundPagesCommand >> asSpecCommand [ 
	
	^ super asSpecCommand 
		iconName: #glamorousMore;
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
		name: 'Pages';
		description: 'Load a saved page.'
]
