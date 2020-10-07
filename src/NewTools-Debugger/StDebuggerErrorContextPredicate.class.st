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

	^ exception class = MessageNotUnderstood and: [ 
		  | message |
		  message := exception message.
		  (exception receiver respondsTo: message selector) not ]
]

{ #category : #predicates }
StDebuggerErrorContextPredicate >> isContextMissingClassException [

	^ exception class == VariableNotDeclared
]

{ #category : #predicates }
StDebuggerErrorContextPredicate >> isContextSubclassResponsibilityException [
	^ exception class == SubclassResponsibility
]

{ #category : #predicates }
StDebuggerErrorContextPredicate >> isSteppable [

	super isSteppable ifFalse: [ ^ false ].

	exception class = MessageNotUnderstood ifTrue: [ 
		^ self isContextDoesNotUnderstand not ].

	^ ((exception isKindOf: OupsNullException) or: [ 
		 exception isKindOf: Halt ])
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
