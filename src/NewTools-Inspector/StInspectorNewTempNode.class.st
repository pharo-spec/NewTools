"
I am a variable node for representing a temporary variable stored in a Context object that has a name attached. 
This includes  local variables and method parameters.
"
Class {
	#name : 'StInspectorNewTempNode',
	#superclass : 'StInspectorNode',
	#instVars : [
		'debugInfo',
		'tempName'
	],
	#category : 'NewTools-Inspector-Model',
	#package : 'NewTools-Inspector',
	#tag : 'Model'
}

{ #category : 'comparing' }
StInspectorNewTempNode >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	nil.
	self class = anObject class ifFalse: [ ^ false ].
	^ tempName = anObject tempName and: [ hostObject = anObject hostObject ]
]

{ #category : 'accessing' }
StInspectorNewTempNode >> children [
	^ #()
]

{ #category : 'accessing' }
StInspectorNewTempNode >> debugInfo [

	^ debugInfo
]

{ #category : 'accessing' }
StInspectorNewTempNode >> debugInfo: anObject [

	debugInfo := anObject
]

{ #category : 'accessing' }
StInspectorNewTempNode >> debugScope [

	^ debugInfo debugScopeAt:
		  (self hostObject executedPC max: self hostObject method initialPC)
]

{ #category : 'comparing' }
StInspectorNewTempNode >> hash [

	"Answer an integer value that is related to the identity of the receiver."

	^ tempName hash bitXor: (hostObject hash)
]

{ #category : 'accessing' }
StInspectorNewTempNode >> hostObject: aContext [

	super hostObject: aContext.
	debugInfo := aContext method debugInfo.
]

{ #category : 'accessing' }
StInspectorNewTempNode >> isArgumentVariable [

	^ self debugScope isArgumentNamed: tempName
]

{ #category : 'accessing' }
StInspectorNewTempNode >> isTempVariable [

	^ self isArgumentVariable not
]

{ #category : 'accessing' }
StInspectorNewTempNode >> key [

	^ tempName
]

{ #category : 'accessing' }
StInspectorNewTempNode >> rawValue [

	^ self debugScope
		  readVariableNamed: tempName
		  fromContext: self hostObject
]

{ #category : 'accessing' }
StInspectorNewTempNode >> tempName [

	^ tempName
]

{ #category : 'accessing' }
StInspectorNewTempNode >> tempName: anObject [

	tempName := anObject
]

{ #category : 'accessing' }
StInspectorNewTempNode >> variableTag [

	^ self isArgumentVariable ifTrue: [ 'arg' ] ifFalse: [ 'temp. var' ]
]
