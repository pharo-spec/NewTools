Class {
	#name : #StPlaygroundPublishCommand,
	#superclass : #LtCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #accessing }
StPlaygroundPublishCommand class >> activations [

	^ { self toolBarActivation }
]

{ #category : #accessing }
StPlaygroundPublishCommand class >> toolBarActivation [

	^ LtToolBarActivation new 
		order: 100;
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
		addGroup: StPlaygroundCommandGroup uniqueInstance;
		name: 'Publish';
		description: 'Publish contents to the cloud.';
		iconName: #glamorousSaveToUrl
]
