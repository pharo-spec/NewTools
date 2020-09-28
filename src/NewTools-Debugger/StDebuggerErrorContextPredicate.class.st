"
I provide a specialized context description in the case where an exception was found on the stack of the context.

I reference that exception.
"
Class {
	#name : #StDebuggerErrorContextPredicate,
	#superclass : #StDebuggerContextPredicate,
	#instVars : [
		'exception'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerErrorContextPredicate >> assertEqualsSelectors [
	self flag: 'Add the denies... use a pragma?'.
	^ #(#assert:equals: #assert:closeTo:precision: #assert:closeTo: #assert:identicalTo: #assertCollection:equals: #assertCollection:hasSameElements:)
	
"#( #assert:equals: #assert:closeTo:precision:
	     #assert:closeTo: #assert:identicalTo: #assertCollection:equals:
	     #assertCollection:hasSameElements: )"
]

{ #category : #accessing }
StDebuggerErrorContextPredicate >> exception: anObject [
	exception := anObject
]

{ #category : #predicates }
StDebuggerErrorContextPredicate >> isContextDoesNotUnderstand [
	true crTrace.
	^ context selector == #doesNotUnderstand: and: [ 
		  | message |
		  message := (context temporaryVariableNamed: #aMessage) 
			             readInContext: context.
		  (context receiver respondsTo: message selector) not ]
]

{ #category : #predicates }
StDebuggerErrorContextPredicate >> isContextMissingClassException [

	^ self isContextDoesNotUnderstand and: [ 
		  context size >= 2 and: [ 
			  (context tempAt: 2) class == VariableNotDeclared ] ]
]

{ #category : #predicates }
StDebuggerErrorContextPredicate >> isContextSubclassResponsibilityException [
	^ context selector == #subclassResponsibility
]

{ #category : #predicates }
StDebuggerErrorContextPredicate >> isSteppable [ 	
	(exception isKindOf: OupsNullException) ifTrue:[false crTrace. ^super isSteppable].
	self isContextSubclassResponsibilityException ifTrue:[^false].
	self isContextAnAssertionFailure ifTrue:[^false].
	self isContextDoesNotUnderstand ifTrue:[^false].
	self isContextMissingClassException ifTrue:[^false].
	^super isSteppable and:[(exception isKindOf: Halt)]
]

{ #category : #printing }
StDebuggerErrorContextPredicate >> printDescription [

	| str |
	str := WriteStream on: String new.
	self printDescriptionPrefixOn: str.
	str << ((exception isKindOf: OupsNullException)
		 ifTrue: [ context printString ]
		 ifFalse: [ exception smartDescription ]).
	^ str contents
]
