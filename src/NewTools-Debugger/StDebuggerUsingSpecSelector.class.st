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

{ #category : #accessing }
StDebuggerUsingSpecSelector class >> debuggerClass [ 	
	^StDebugger
]

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

{ #category : #accessing }
StDebuggerUsingSpecSelector >> debuggerClass [ 
	^self class debuggerClass
]

{ #category : #'specs - selectors' }
StDebuggerUsingSpecSelector >> isDefaultSelector: aSelector [
	^ {self class defaultDebuggerWithExtensionSpecSelector.
	self class defaultDebuggerWithoutExtensionSpecSelector}
		includes: aSelector
]

{ #category : #'specs - selectors' }
StDebuggerUsingSpecSelector >> selectExtensionActivationSpecFrom: aSpecSelector [
	"If the current selector is not a default one, it is returned.
	If it is a default one, it is altered depending on the current configuration of the debugger extensions.
	The selection just adds or remove the extensions from the spec selector"

	(self isDefaultSelector: aSpecSelector)
		ifFalse: [ ^ aSpecSelector ].
	^ self
		selectorForDebuggerStatus: self debuggerClass activateDebuggerExtensions
		extensionsStatus: self debuggerClass hasAnyActivatedExtension
]

{ #category : #'specs - selectors' }
StDebuggerUsingSpecSelector >> selectSpecSelector [
	"Sets and returns the spec selector to be use by the presenter.
	Two cases:
	- current selector exists or is not valid: returns default spec selector with extensions
	- current selector exists: select a version with or without debugger extensions"
	| selector |
	selector := (specSelector isNil
		or: [ (self debuggerClass respondsTo: specSelector) not ])
		ifTrue: [ self class defaultDebuggerWithExtensionSpecSelector ]
		ifFalse: [ specSelector ].
	^ self selectExtensionActivationSpecFrom: selector
]

{ #category : #'specs - selectors' }
StDebuggerUsingSpecSelector >> selectorForDebuggerStatus: debuggerExtensionsActivated extensionsStatus: debuggerHasExtensions [
	self flag: 'This seems wrong: we should adapt the layout and its size directly and not testing and choosing other selectors because this does not scale...'.
	^ (debuggerExtensionsActivated and: [ debuggerHasExtensions ])
		ifTrue: [ self class defaultDebuggerWithExtensionSpecSelector ]
		ifFalse: [ self class defaultDebuggerWithoutExtensionSpecSelector ]
]

{ #category : #'default spec selectors' }
StDebuggerUsingSpecSelector >> specSelector [
	^ specSelector
]

{ #category : #accessing }
StDebuggerUsingSpecSelector >> specSelector: anObject [
	specSelector := anObject
]
