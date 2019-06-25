Class {
	#name : #StPlaygroundDoItCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #converting }
StPlaygroundDoItCommand >> asSpecCommand [ 
	
	^ super asSpecCommand 
		iconName: #glamorousGo;
		yourself
]

{ #category : #execution }
StPlaygroundDoItCommand >> execute [ 

	self inform: 'TODO'
]

{ #category : #initialization }
StPlaygroundDoItCommand >> initialize [ 
	
	super initialize.
	self 
		basicName: 'Do it';
		basicDescription: 'Do it all and inspect.'
]
