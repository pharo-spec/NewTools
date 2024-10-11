"
I am a simple wrapper holding the current context and the current debug session in a debugger.
My purpose is only to display context and debug session related information in the debugger inspector.
"
Class {
	#name : 'StDebuggerContext',
	#superclass : 'Object',
	#instVars : [
		'context',
		'exception',
		'debugger'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StDebuggerContext class >> context: aContext [

	^ self new
		  context: aContext;
		  yourself
]

{ #category : 'nodes' }
StDebuggerContext >> assertionNodesFor: anAssertionFailureResult [

	| assertionFailure nodes|
	nodes := OrderedCollection new.
	[
	assertionFailure := self exception signalerContext
		                    findFailedAssertionResultsInSenderChain ]
		on: StDebuggeAssertionFailureContextNotFound
		do: [ ^ nodes ].
	
	nodes add: (StInspectorDynamicNode hostObject: assertionFailure expected label: 'expected' value: assertionFailure expected ).
	nodes add: (StInspectorDynamicNode hostObject: assertionFailure actual label: 'actual' value: assertionFailure actual ).
	^nodes
]

{ #category : 'accessing' }
StDebuggerContext >> buildExtensionNodes [

	| visitor |
	visitor := StDebuggerExtensionInspectorNodeBuilderVisitor new.

	^ debugger
		  ifNotNil: [ 
			  debugger extensionTools do: [ :debuggerExtension | 
				  visitor visit: debuggerExtension ].
			  visitor result ]
		  ifNil: [ #(  ) asOrderedCollection ]
]

{ #category : 'accessing' }
StDebuggerContext >> buildInspectorNodes [

	| nodes argsNodes tempsNodes tempsAndArgs |
	nodes := OrderedCollection new.
	tempsAndArgs := self temporaryVariablesNodes.
	argsNodes := tempsAndArgs select: [ :tempNode | 
		             tempNode tempVariable isArgumentVariable ].
	tempsNodes := tempsAndArgs select: [ :tempNode | 
		              tempNode tempVariable isTempVariable ].
	nodes add: self selfNode.
	nodes addAll: argsNodes.
	nodes addAll: tempsNodes.
	nodes addAll: self receiverNodes.
	nodes add: self stackTopNode.
	nodes add: self thisContextNode.
	nodes addAll: self exceptionNodes.
	nodes addAll: self buildExtensionNodes.
	^ nodes
]

{ #category : 'accessing' }
StDebuggerContext >> context [

	^ context ifNil: [ context := [] asContext ]
]

{ #category : 'accessing' }
StDebuggerContext >> context: anObject [
	context := anObject
]

{ #category : 'accessing' }
StDebuggerContext >> debugger: aDebugger [

	debugger := aDebugger
]

{ #category : 'building' }
StDebuggerContext >> doesNotUnderstandNodesFor: anException [

	^ (self exceptionNodesFor: anException)
		  add: (StInspectorDynamicNode
				   hostObject: anException receiver
				   label: 'DNU receiver'
				   value: anException receiver);
		  yourself
]

{ #category : 'accessing' }
StDebuggerContext >> exception [
	^ exception ifNil:[exception := OupsNullException new]
]

{ #category : 'accessing' }
StDebuggerContext >> exception: anException [
	exception := anException 
]

{ #category : 'nodes' }
StDebuggerContext >> exceptionNodes [

	^ self exception stDebuggerInspectorNodesFor: self
]

{ #category : 'building' }
StDebuggerContext >> exceptionNodesFor: anException [

	^ OrderedCollection new
		  add: (StInspectorDynamicNode
				   hostObject: anException
				   label: 'Exception'
				   value: anException);
		  yourself
]

{ #category : 'building' }
StDebuggerContext >> nullExceptionNodesFor: anException [

	^ #(  )
]

{ #category : 'printing' }
StDebuggerContext >> printOn: aStream [
	aStream nextPutAll: context asString 
]

{ #category : 'nodes' }
StDebuggerContext >> receiverNodes [

	^ self context receiver allInspectorNodes reject: [ :node | 
		  node label = 'self' ]
]

{ #category : 'nodes' }
StDebuggerContext >> selfNode [

	^ StInspectorSelfNode hostObject: (self context home ifNotNil: [:home | home receiver])
]

{ #category : 'nodes' }
StDebuggerContext >> stackTopNode [
	^StInspectorStackTopNode hostObject: self context
]

{ #category : 'nodes' }
StDebuggerContext >> temporaryVariablesNodes [

	^ self context astScope allTemps collect: [ :temp | 
		  (StInspectorTempNode hostObject: self context) tempVariable: temp ]
]

{ #category : 'nodes' }
StDebuggerContext >> thisContextNode [ 
	^StInspectorThisContextNode hostObject: self context
]
