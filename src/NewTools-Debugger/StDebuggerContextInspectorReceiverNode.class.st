Class {
	#name : #StDebuggerContextInspectorReceiverNode,
	#superclass : #StDebuggerContextInspectorNode,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerContextInspectorReceiverNode >> computeChildrenFromSourceObject [
	^ hostObject context home receiver allInspectorNodes
		reject: [ :node | node key = 'self' ]
]

{ #category : #accessing }
StDebuggerContextInspectorReceiverNode >> label [
	^ 'Receiver'
]

{ #category : #accessing }
StDebuggerContextInspectorReceiverNode >> rawValue [
	^ hostObject context home receiver
]
