Class {
	#name : #StDebuggerInspectorModel,
	#superclass : #StInspectorModel,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerInspectorModel >> labelString [
	^ 'Receiver in: ' , super labelString
]
