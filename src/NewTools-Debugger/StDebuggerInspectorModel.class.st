Class {
	#name : #StDebuggerInspectorModel,
	#superclass : #StInspectorModel,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'as yet unclassified' }
StDebuggerInspectorModel >> defaultObjectInspectorClass [
	^StDebuggerRawObjectInspector
]

{ #category : #accessing }
StDebuggerInspectorModel >> labelString [
	^ 'Receiver in: ' , super labelString
]
