Class {
	#name : #StDebuggerContextInteractionModel,
	#superclass : #SpCodeInteractionModel,
	#instVars : [
		'context'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'instance creation' }
StDebuggerContextInteractionModel class >> on: aContext [

	^ self new context: aContext
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> behavior [

	^ self context receiver class
]

{ #category : #binding }
StDebuggerContextInteractionModel >> bindingOf: aString [

	"we can not call #lookupVar: without checking first as it would create the variable"

	^ (self hasBindingOf: aString)
		  ifTrue: [ (context lookupVar: aString) asDoItVariableFrom: context ]
		  ifFalse: [ nil ]
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
StDebuggerContextInteractionModel >> hasBindingOf: aString [
	"we lookup the name without creating a new variable"
	^ (context lookupVar: aString declare: false) notNil
]

{ #category : #testing }
StDebuggerContextInteractionModel >> hasUnsavedCodeChanges [

	^ context notNil and: [ context sourceCode ~= owner text asString ]
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> object [

	^ self doItReceiver
]
