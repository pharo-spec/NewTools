Class {
	#name : #StInspectorSelfNode,
	#superclass : #StInspectorNode,
	#category : #'NewTools-Inspector-Model'
}

{ #category : #accessing }
StInspectorSelfNode >> children [
 
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
