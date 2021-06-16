"
Toggle the scope of a variable (shared or local)
"
Class {
	#name : #StToggleBindingCommand,
	#superclass : #StCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #default }
StToggleBindingCommand class >> defaultDescription [

	^ 'Switch binding scope from local to shared and viceversa.'
]

{ #category : #default }
StToggleBindingCommand class >> defaultName [

	^ 'Move to shared/local scope'
]

{ #category : #accessing }
StToggleBindingCommand class >> moveToLocalName [

	^ 'Make binding local'
]

{ #category : #accessing }
StToggleBindingCommand class >> moveToSharedName [

	^ 'Make binding shared'
]

{ #category : #executing }
StToggleBindingCommand >> execute [
	
	context toggleSelectedBindingScope
]

{ #category : #accessing }
StToggleBindingCommand >> name [

	context ifNil: [ ^ super name ].

	^ context selectedBindingIsLocal
		ifTrue: [ self class moveToSharedName ]
		ifFalse: [ self class moveToLocalName ]
]
