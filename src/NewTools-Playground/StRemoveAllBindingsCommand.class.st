"
Remove all local bindings (notice that shared bindings will remain)
"
Class {
	#name : #StRemoveAllBindingsCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #accessing }
StRemoveAllBindingsCommand >> application [

	^ StPharoApplication current
]

{ #category : #converting }
StRemoveAllBindingsCommand >> asSpecCommand [ 
	
	^ super asSpecCommand 
		iconProvider: self application;
		iconName: #smallDelete;
		yourself
]

{ #category : #executing }
StRemoveAllBindingsCommand >> execute [
	
	context removeAllBindings
]

{ #category : #initialization }
StRemoveAllBindingsCommand >> initialize [
	super initialize.
	self
		name: 'Remove all bindings';
		description: 'Remove all local bindings (shared will stay alive).'
]
