Class {
	#name : #StMoveBindingCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #accessing }
StMoveBindingCommand class >> moveToLocalName [

	^ 'Make binding local'
]

{ #category : #accessing }
StMoveBindingCommand class >> moveToSharedName [

	^ 'Make binding shared'
]

{ #category : #accessing }
StMoveBindingCommand >> application [

	^ StPharoApplication current
]

{ #category : #executing }
StMoveBindingCommand >> execute [
	
	context toggleSelectedBindingScope
]

{ #category : #initialization }
StMoveBindingCommand >> initialize [

	super initialize.
	self
		name: 'Move to shared/local scope';
		description: 'Switch binding scope from local to shared and viceversa.'
]

{ #category : #accessing }
StMoveBindingCommand >> name [

	context ifNil: [ ^ super name ].

	^ context selectedBindingIsLocal
		ifTrue: [ self class moveToSharedName ]
		ifFalse: [ self class moveToLocalName ]
]
