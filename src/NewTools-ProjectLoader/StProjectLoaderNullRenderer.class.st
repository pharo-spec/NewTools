"
I am a simple null renderer.
I just return the same the string that I receive as argument.
"
Class {
	#name : #StProjectLoaderNullRenderer,
	#superclass : #StProjectLoaderRenderer,
	#category : #'NewTools-ProjectLoader'
}

{ #category : #testing }
StProjectLoaderNullRenderer class >> priority [

	^ 1
]

{ #category : #parsing }
StProjectLoaderNullRenderer >> render: anString [

	^ anString
]
