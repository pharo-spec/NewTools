Class {
	#name : #StPlaygroundBindingsCommand,
	#superclass : #StPlaygroundCommand,
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

	(StPlaygroundBindingsPresenter 
		newApplication: context application 
		model: context) 
		openDialogWithSpec
]

{ #category : #initialization }
StPlaygroundBindingsCommand >> initialize [
	super initialize.
	self
		name: 'Bindings';
		description: 'Edit bindings list.'
]
