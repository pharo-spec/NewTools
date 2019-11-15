Class {
	#name : #StDebuggerContextInspectorTempsNode,
	#superclass : #StDebuggerContextInspectorNode,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerContextInspectorTempsNode >> computeChildrenFromSourceObject [
	^ (StNodeCollector for: hostObject) collectTempsNodes
]

{ #category : #accessing }
StDebuggerContextInspectorTempsNode >> label [
	^ 'Temps'
]

{ #category : #accessing }
StDebuggerContextInspectorTempsNode >> rawValue [
	^ hostObject context temporaries
]
