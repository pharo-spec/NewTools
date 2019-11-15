"
I provide control over halts messages and breakpoints for activating and deactivating them.
I also tell if a program node has active breakpoints or halts on it.
"
Class {
	#name : #StHaltAndBreakpointController,
	#superclass : #Object,
	#classInstVars : [
		'tracer'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #API }
StHaltAndBreakpointController class >> skipHaltNode: aProgramNode [
	self
		trace:
			(aProgramNode methodNode source asText
				makeBoldFrom: aProgramNode start to: aProgramNode stop;
				yourself)
]

{ #category : #Helpers }
StHaltAndBreakpointController class >> trace: aTextOrString [
	self tracer crTrace: aTextOrString
]

{ #category : #Helpers }
StHaltAndBreakpointController class >> tracer [
	^ tracer ifNil: [ tracer := Transcript ]
]

{ #category : #Helpers }
StHaltAndBreakpointController class >> tracer: aTracer [
	tracer := aTracer
]

{ #category : #control }
StHaltAndBreakpointController >> disableBreakpointNode: aProgramNode [
]

{ #category : #links }
StHaltAndBreakpointController >> disableHaltLink [
	^ MetaLink new
		metaObject: self class;
		selector: #skipHaltNode:;
		arguments: #(node);
		control: #instead;
		yourself
]

{ #category : #control }
StHaltAndBreakpointController >> disableHaltNode: aMessageNode [
	aMessageNode link: self disableHaltLink
]

{ #category : #API }
StHaltAndBreakpointController >> disableHaltOrBreakpointFor: aProgramNode [
	aProgramNode isHaltNode
		ifTrue: [ self disableHaltNode: aProgramNode ].
	self disableBreakpointNode: aProgramNode
]

{ #category : #control }
StHaltAndBreakpointController >> enableBreakpointNode: aProgramNode [
]

{ #category : #control }
StHaltAndBreakpointController >> enableHaltNode: aMessageNode [
	(aMessageNode links
		select: [ :link | link control = #instead and: [ link metaObject == self class ] ])
		do: [ :link | link uninstall ]
]

{ #category : #API }
StHaltAndBreakpointController >> enableHaltOrBreakpointFor: aProgramNode [
	aProgramNode isHaltNode
		ifTrue: [ self enableHaltNode: aProgramNode ].
	self enableBreakpointNode: aProgramNode
]

{ #category : #API }
StHaltAndBreakpointController >> haltOrBreakpointNodeActiveOn: aProgramNode [
	^ aProgramNode enabledForHaltOrBreakpoint
]
