Class {
	#name : #StDebuggerContextInteractionModel,
	#superclass : #SpCodeInteractionModel,
	#instVars : [
		'context',
		'bindings'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'instance creation' }
StDebuggerContextInteractionModel class >> on: aContext [

	^ self new context: aContext
]

{ #category : #adding }
StDebuggerContextInteractionModel >> addBinding: aBinding [

	self flag: 'This is experimental code to add a binding without writing code'.
	self bindings add: aBinding 
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> behavior [

	^ self context receiver class
]

{ #category : #binding }
StDebuggerContextInteractionModel >> bindingOf: aString [

	"we can not call #lookupVar: without checking first as it would create the variable"

	^ (self hasBindingInContextOf: aString)
		  ifTrue: [ 
		  (context lookupVar: aString) asDoItVariableFrom: context ]
		  ifFalse: [ 
			  (self hasBindingInInteractionModelOf: aString)
				  ifTrue: [ self bindings associationAt: aString ]
				  ifFalse: [ nil ] ]
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> bindings [

	^ bindings ifNil: [ bindings := Dictionary new ]
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> context [

	^context
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> context: aContext [
	context := aContext
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> doItContext [

	^ self context
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> doItReceiver [

	^ self context receiver
]

{ #category : #testing }
StDebuggerContextInteractionModel >> hasBindingInContextOf: aString [
	"we lookup the name without creating a new variable"
	^ (context lookupVar: aString declare: false) notNil
]

{ #category : #testing }
StDebuggerContextInteractionModel >> hasBindingInInteractionModelOf: aString [
	"we search the name in the interaction model as we would do in a playground"
	^ self bindings includesKey: aString
]

{ #category : #testing }
StDebuggerContextInteractionModel >> hasBindingOf: aString [

	"we lookup the name without creating a new variable then we search in the interaction model"

	^ (self hasBindingInContextOf: aString) or: [ 
		  self hasBindingInInteractionModelOf: aString ]
]

{ #category : #testing }
StDebuggerContextInteractionModel >> hasUnsavedCodeChanges [

	^ context notNil and: [ context sourceCode ~= owner text asString ]
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> object [

	^ self doItReceiver
]
