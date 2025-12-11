Class {
	#name : 'StDebuggerMetaSession',
	#superclass : 'Object',
	#instVars : [
		'debugger'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StDebuggerMetaSession class >> forDebugger: aStDebugger [
	^self new forDebugger: aStDebugger
]

{ #category : 'accessing' }
StDebuggerMetaSession >> allInspectorNodes [
	"Answer a list of attributes as nodes"

	^ OrderedCollection new
		  addAll: debugger debuggerClientModel inspectorNodes;
		  add: (StInspectorDynamicNode
				   hostObject: debugger
				   label: 'debugger'
				   value: debugger);
		  yourself
]

{ #category : 'instance creation' }
StDebuggerMetaSession >> forDebugger: aStDebugger [

	debugger := aStDebugger
]
