Class {
	#name : #StPlaygroundPublishCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #converting }
StPlaygroundPublishCommand >> asSpecCommand [ 
	
	^ super asSpecCommand 
		iconName: #glamorousSaveToUrl;
		yourself

]

{ #category : #execution }
StPlaygroundPublishCommand >> execute [ 

	self inform: #TODO.
]

{ #category : #initialization }
StPlaygroundPublishCommand >> initialize [ 
	
	super initialize.
	self 
		basicName: 'Publish';
		basicDescription: 'Publish contents to the cloud.'
]
