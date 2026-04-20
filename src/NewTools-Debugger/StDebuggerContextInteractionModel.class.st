Class {
	#name : 'StDebuggerContextInteractionModel',
	#superclass : 'SpContextInteractionModel',
	#instVars : [
		'bindings',
		'interactive'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StDebuggerContextInteractionModel class >> on: aContext [

	^ self new context: aContext
]

{ #category : 'adding' }
StDebuggerContextInteractionModel >> addBinding: aBinding [

	self flag: 'This is experimental code to add a binding without writing code'.
	self bindings add: aBinding 
]

{ #category : 'accessing' }
StDebuggerContextInteractionModel >> beNonInteractive [

	interactive := false
]

{ #category : 'binding' }
StDebuggerContextInteractionModel >> bindingOf: aString [

	"we can not call #lookupVar: without checking first as it would create the variable"

	^ (self hasBindingInContextOf: aString)
		  ifTrue: [ 
		  (context lookupVar: aString) asDoItVariableFrom: context ]
		  ifFalse: [ self bindings associationAt: aString ifAbsent: [ nil ] ]
]

{ #category : 'accessing' }
StDebuggerContextInteractionModel >> bindings [

	^ bindings ifNil: [ bindings := Dictionary new ] 
]

{ #category : 'accessing' }
StDebuggerContextInteractionModel >> compiler [
	"Provide a compiler set up on the current context/class/receiver"

	^ self doItReceiver class compiler
		context: self doItContext;
		receiver: self doItReceiver;
		isScripting: self isScripting;
		requestor: self;
		yourself
]

{ #category : 'testing' }
StDebuggerContextInteractionModel >> hasBindingInContextOf: aString [
	^ (context lookupVar: aString) isNotNil
]

{ #category : 'testing' }
StDebuggerContextInteractionModel >> hasBindingInInteractionModelOf: aString [
	"we search the name in the interaction model as we would do in a playground"
	^ self bindings includesKey: aString
]

{ #category : 'testing' }
StDebuggerContextInteractionModel >> hasBindingOf: aString [

	"we lookup the name without creating a new variable then we search in the interaction model"

	^ (self hasBindingInContextOf: aString) or: [ 
		  self hasBindingInInteractionModelOf: aString ]
]

{ #category : 'accessing' }
StDebuggerContextInteractionModel >> initialize [

	super initialize.
	interactive := true
]

{ #category : 'accessing' }
StDebuggerContextInteractionModel >> interactive [

	^ interactive
]

{ #category : 'testing' }
StDebuggerContextInteractionModel >> needRequestorScope [

	^ true
]
