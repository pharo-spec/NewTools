Class {
	#name : #StInspectorTransmissionNode,
	#superclass : #StInspectorNode,
	#instVars : [
		'transmissionBlock'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'instance initialization' }
StInspectorTransmissionNode class >> hostObject: anObject transmissionBlock: aFullBlockClosure [

	^ self new
		  hostObject: anObject;
		  transmissionBlock: aFullBlockClosure;
		  yourself
]

{ #category : #accessing }
StInspectorTransmissionNode >> key [

	^ self hostObject
]

{ #category : #accessing }
StInspectorTransmissionNode >> rawValue [

	^ transmissionBlock value: hostObject
]

{ #category : #accessing }
StInspectorTransmissionNode >> transmissionBlock: aBlock [

	transmissionBlock := aBlock
]
