"
I am an inspector node that allows the user to specify a custom transmission. I am made to be used inside the Inspector. The user can specify the `transmissionBlock:`
"
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
StInspectorTransmissionNode >> transmits: aBlock [

	transmissionBlock := aBlock
]
