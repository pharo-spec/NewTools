"
A model for the `thisContext` variable.
This is to be used when debugging.
"
Class {
	#name : 'StInspectorThisContextNode',
	#superclass : 'StInspectorNode',
	#category : 'NewTools-Inspector-Model',
	#package : 'NewTools-Inspector',
	#tag : 'Model'
}

{ #category : 'accessing' }
StInspectorThisContextNode >> key [
	^ 'thisContext'
]

{ #category : 'accessing' }
StInspectorThisContextNode >> rawValue [

	^ self hostObject
]
