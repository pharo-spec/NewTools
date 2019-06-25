Class {
	#name : #StPlaygroundPagesCommand,
	#superclass : #CmCommand,
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
		basicName: 'Pages';
		basicDescription: 'Load a saved page.'
]
