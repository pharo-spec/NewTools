Class {
	#name : #StDebuggerInspectorModel,
	#superclass : #StInspectorModel,
	#category : #'NewTools-Debugger'
}

{ #category : #accessing }
StDebuggerInspectorModel >> allInspectorNodes [

	^ self debuggerInspectorNodes
]

{ #category : #converting }
StDebuggerInspectorModel >> asDebuggerInspectorModel [

	^ self
]
