"
I select and returns the spec selector to be used by the StDebugger presenter.
	Two cases:
	- current selector exists or is not valid: returns default spec selector with debugger extensions
	- current selector exists: select a version with or without debugger extensions
	
Three cases:
	- custom selector: returned as is
	- selector is one of the display strategy with or without debugger extensions
		- extensions activated: force return of spec selector with extensions
		- extensions not activated: force return of spec selector without extensions
		
	Checks performed to tell if extensions are activated:
		- activateDebuggerExtensions must be true
		- AND at least one existing extension class is activated as debugger extension
"
Class {
	#name : #StDebuggerUsingSpecSelector,
	#superclass : #Object,
	#instVars : [
		'specSelector'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'default spec selectors' }
StDebuggerUsingSpecSelector class >> defaultDebuggerWithExtensionSpecSelector [
	^#debuggerWithExtensionsSpec
]

{ #category : #'default spec selectors' }
StDebuggerUsingSpecSelector class >> defaultDebuggerWithoutExtensionSpecSelector [
	^#debuggerWithoutExtensionsSpec
]

{ #category : #'instance creation' }
StDebuggerUsingSpecSelector class >> defaultSelector [
	^self on: self defaultDebuggerWithExtensionSpecSelector
]

{ #category : #'instance creation' }
StDebuggerUsingSpecSelector class >> on: aSelector [
	^self new specSelector: aSelector
]

{ #category : #'specs - selectors' }
StDebuggerUsingSpecSelector >> selectExtensionActivationSpecFrom: aSpecSelector [
"Three cases:
	- custom selector: returned as is
	- selector is one of the display strategy with or without debugger extensions
		- extensions activated: force return of spec selector with extensions
		- extensions not activated: force return of spec selector without extensions
		
	Checks performed to tell if extensions are activated:
		- activateDebuggerExtensions must be true
		- AND at least one existing extension class is activated as debugger extension"
	|activatedExtensions|
	({self class defaultDebuggerWithExtensionSpecSelector.
	self class defaultDebuggerWithoutExtensionSpecSelector}
		includes: aSpecSelector)
		ifFalse: [ ^ aSpecSelector ].
	activatedExtensions := SpecDebugger collectExtendedToolsClasses select:[:toolClass| toolClass showInDebugger].
	^ (SpecDebugger activateDebuggerExtensions and:[activatedExtensions notEmpty])
		ifTrue: [ self class defaultDebuggerWithExtensionSpecSelector ]
		ifFalse: [ self class defaultDebuggerWithoutExtensionSpecSelector ]
]

{ #category : #'specs - selectors' }
StDebuggerUsingSpecSelector >> selectSpecSelector [
	"Sets and returns the spec selector to be use by the presenter.
	Two cases:
	- current selector exists or is not valid: returns default spec selector with extensions
	- current selector exists: select a version with or without debugger extensions"
	| selector |
	selector := (specSelector isNil
		or: [ (SpecDebugger respondsTo: specSelector) not ])
		ifTrue: [ self class defaultDebuggerWithExtensionSpecSelector ]
		ifFalse: [ specSelector ].
	^ self selectExtensionActivationSpecFrom: selector
]

{ #category : #accessing }
StDebuggerUsingSpecSelector >> specSelector: anObject [
	specSelector := anObject
]
