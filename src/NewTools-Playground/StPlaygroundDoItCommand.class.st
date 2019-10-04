Class {
	#name : #StPlaygroundDoItCommand,
	#superclass : #StPlaygroundCommand,
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
		name: 'Do it';
		description: 'Do it all and inspect.'
]
