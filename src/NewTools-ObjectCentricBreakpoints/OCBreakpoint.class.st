"
I am a breakpoint that is scoped to one single specific object.
I halt the object's execution when it receives a particular message or when one of its instance variable is accessed.

There are uncovered behavior, such as if you try to halt on a state access defined in one of my super classes.

API: see Object > class > NewTools-ObjectCentricBreakpoints extension.


"
Class {
	#name : #OCBreakpoint,
	#superclass : #Breakpoint,
	#instVars : [
		'targetObject'
	],
	#classInstVars : [
		'registry'
	],
	#category : #'NewTools-ObjectCentricBreakpoints'
}

{ #category : #registry }
OCBreakpoint class >> breakpointForObject: anObject [
	^self registryAt: anObject
]

{ #category : #registry }
OCBreakpoint class >> registerBreakpoint: ocBreakpoint forObject: anObject [
	self setClassIndirectionForObjectCentricInstrumentedObject: anObject.
	(self breakpointForObject: anObject) add: ocBreakpoint
]

{ #category : #accessing }
OCBreakpoint class >> registry [ 	
	^registry ifNil:[registry := WeakKeyDictionary new]
]

{ #category : #registry }
OCBreakpoint class >> registryAt: anObject [
	^ self registry at: anObject ifAbsentPut: Set new
]

{ #category : #registry }
OCBreakpoint class >> removeObjectCentricBreakpointsFrom: anObject [
	(self breakpointForObject: anObject)
		do: [ :ocBreakpoint | ocBreakpoint uninstall ].
	self registry removeKey: anObject
]

{ #category : #reflection }
OCBreakpoint class >> setClassIndirectionForObjectCentricInstrumentedObject: anObject [
	| class |
	self
		flag: 'This should be moved to the object-centric mechanism as an option.'.
	class := anObject class.
	class isAnonymous
		ifTrue: [ class methodDict
				at: #class
				ifAbsent: [ class compile: 'class ^super class superclass' ] ]
]

{ #category : #registry }
OCBreakpoint class >> uninstallAll [
	<script>
	self registry keys
		do: [ :anObject | self removeObjectCentricBreakpointsFrom: anObject ]
]

{ #category : #registry }
OCBreakpoint class >> uninstallAllForObject: anObject [
	<script>
	self removeObjectCentricBreakpointsFrom: anObject
]

{ #category : #'api - state access' }
OCBreakpoint >> haltTarget: anObject onAccess: access to: instVarName [
	targetObject := anObject.
	self always.
	targetObject link: self link toSlotNamed: instVarName option: access.
	self registerObjectCentricBreakpoint
]

{ #category : #'api - on call' }
OCBreakpoint >> haltTarget: anObject onCallTo: methodSelector [
	targetObject := anObject.
	self installOnMethodNamed: methodSelector.
	^ self
]

{ #category : #install }
OCBreakpoint >> installOn: anObject for: methodName [
	self always.
	anObject link: self link toMethodNamed: methodName
]

{ #category : #install }
OCBreakpoint >> installOnMethodNamed: methodName [
	self installOn: targetObject for: methodName.
	self registerObjectCentricBreakpoint
]

{ #category : #install }
OCBreakpoint >> registerObjectCentricBreakpoint [
	self registry registerBreakpoint: self forObject: targetObject
]

{ #category : #accessing }
OCBreakpoint >> registry [
	^ self class
]

{ #category : #accessing }
OCBreakpoint >> targetObject [
	^ targetObject
]

{ #category : #accessing }
OCBreakpoint >> targetObject: anObject [
	targetObject := anObject
]

{ #category : #install }
OCBreakpoint >> uninstall [
	self link linkInstaller uninstallPermaLinkFor: self link.
	self link uninstall
]
