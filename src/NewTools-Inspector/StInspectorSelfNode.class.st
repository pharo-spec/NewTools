Class {
	#name : #StInspectorSelfNode,
	#superclass : #StInspectorNode,
	#category : #'NewTools-Inspector-Model'
}

{ #category : #composition }
StInspectorSelfNode >> childrenNodesFor: aVariablesBrowser [
	"Self node does not have any subvariables, just return empty collection"

	^ #()
]

{ #category : #accessing }
StInspectorSelfNode >> key [
	^ 'self'
]

{ #category : #accessing }
StInspectorSelfNode >> rawValue [
	^ self hostObject
]
