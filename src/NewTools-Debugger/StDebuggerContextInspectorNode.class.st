Class {
	#name : #StDebuggerContextInspectorNode,
	#superclass : #StInspectorNode,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerContextInspectorNode >> children [ 
	^self computeChildrenFromSourceObject
]

{ #category : #accessing }
StDebuggerContextInspectorNode >> computeChildrenFromSourceObject [
	^self subclassResponsibility 
]

{ #category : #accessing }
StDebuggerContextInspectorNode >> key [
	^self label
]
