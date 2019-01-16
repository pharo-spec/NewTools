Class {
	#name : #StPlaygroundBindingsCommand,
	#superclass : #LtCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #accessing }
StPlaygroundBindingsCommand class >> activations [

	^ { self toolBarActivation }
]

{ #category : #accessing }
StPlaygroundBindingsCommand class >> toolBarActivation [

	^ LtToolBarActivation new 
		order: 20;
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
		addGroup: StPlaygroundCommandGroup uniqueInstance;
		name: 'Bindings';
		description: 'Edit bindings list.';
		iconName: #glamorousTable
]
