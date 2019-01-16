Class {
	#name : #StInspectorSlotNode,
	#superclass : #StInspectorNode,
	#instVars : [
		'slot'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'instance creation' }
StInspectorSlotNode class >> newObject: anObject slot: aSlot [

	^ self basicNew 
		initializeObject: anObject slot: aSlot;
		yourself
]

{ #category : #accessing }
StInspectorSlotNode >> children [ 
	
	^ self value inspectorNodes
]

{ #category : #initialization }
StInspectorSlotNode >> initializeObject: anObject slot: aSlot [

	self initialize.
	self object: anObject.
	slot := aSlot
]

{ #category : #accessing }
StInspectorSlotNode >> name [

	^ self slot name
]

{ #category : #accessing }
StInspectorSlotNode >> slot [
	^ slot
]

{ #category : #accessing }
StInspectorSlotNode >> value [ 

	^ self slot read: self object
]
