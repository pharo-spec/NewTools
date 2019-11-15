Class {
	#name : #StDebuggerContextInspectorContextNode,
	#superclass : #StDebuggerContextInspectorNode,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerContextInspectorContextNode >> computeChildrenFromSourceObject [
	^ (StNodeCollector for: hostObject) collectContextNodes
]

{ #category : #accessing }
StDebuggerContextInspectorContextNode >> label [
	^'Context'
]

{ #category : #accessing }
StDebuggerContextInspectorContextNode >> rawValue [
	^ hostObject context
]
