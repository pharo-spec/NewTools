Class {
	#name : #StPlaygroundBindingsCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #converting }
StPlaygroundBindingsCommand >> asSpecCommand [ 
	
	^ super asSpecCommand 
		iconName: #glamorousTable;
		yourself
]

{ #category : #execution }
StPlaygroundBindingsCommand >> execute [ 

	self inform: #TODO.
]

{ #category : #initialization }
StPlaygroundBindingsCommand >> initialize [ 
	
	super initialize.
	self 
		basicName: 'Bindings';
		basicDescription: 'Edit bindings list.'
]
