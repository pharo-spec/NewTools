"
I am a variable node for representing a temporary variable stored in a Context object that has a name attached. 
This includes  local variables and method parameters.
"
Class {
	#name : 'StInspectorTempNode',
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
StInspectorTempNode >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	nil.
	self class = anObject class ifFalse: [ ^ false ].
	^ tempName = anObject tempName and: [ hostObject = anObject hostObject ]
]

{ #category : 'accessing' }
StInspectorTempNode >> children [
	^ #()
]

{ #category : 'accessing' }
StInspectorTempNode >> debugInfo [

	^ debugInfo
]

{ #category : 'accessing' }
StInspectorTempNode >> debugInfo: anObject [

	debugInfo := anObject
]

{ #category : 'accessing' }
StInspectorTempNode >> debugScope [

	^ debugInfo debugScopeAt:
		  (self hostObject executedPC max: self hostObject method initialPC)
]

{ #category : 'comparing' }
StInspectorTempNode >> hash [

	"Answer an integer value that is related to the identity of the receiver."

	^ tempName hash bitXor: (hostObject hash)
]

{ #category : 'accessing' }
StInspectorTempNode >> hostObject: aContext [

	super hostObject: aContext.
	debugInfo := aContext method debugInfo.
]

{ #category : 'accessing' }
StInspectorTempNode >> isArgumentVariable [

	^ self debugScope isArgumentNamed: tempName
]

{ #category : 'accessing' }
StInspectorTempNode >> isTempVariable [

	^ self isArgumentVariable not
]

{ #category : 'accessing' }
StInspectorTempNode >> key [

	^ tempName
]

{ #category : 'accessing' }
StInspectorTempNode >> rawValue [

	^ self debugScope
		  readVariableNamed: tempName
		  fromContext: self hostObject
]

{ #category : 'accessing' }
StInspectorTempNode >> tempName [

	^ tempName
]

{ #category : 'accessing' }
StInspectorTempNode >> tempName: anObject [

	tempName := anObject
]

{ #category : 'accessing' }
StInspectorTempNode >> variableTag [

	^ self isArgumentVariable ifTrue: [ 'arg' ] ifFalse: [ 'temp. var' ]
]
