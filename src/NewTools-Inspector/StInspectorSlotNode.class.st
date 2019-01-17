Class {
	#name : #StInspectorSlotNode,
	#superclass : #StInspectorNode,
	#instVars : [
		'slot'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'instance creation' }
StInspectorSlotNode class >> hostObject: anObject slot: aSlot [
	^ (self hostObject: anObject)
		slot: aSlot;
		yourself
]

{ #category : #accessing }
StInspectorSlotNode >> browsingActionsForNode [

	^ {
			GLMGenericAction new 
				action: [ self systemNavigation browseAllAccessesTo: self label from: self hostObject class ]; 
				title: 'List methods using this variable'.
			GLMGenericAction new 
				action: [ self systemNavigation browseAllStoresInto: self label from: self hostObject class ]; 
				title: 'List methods storing into this variable'.		
		}
]

{ #category : #accessing }
StInspectorSlotNode >> children [ 
	
	^ self value inspectorNodes
]

{ #category : #accessing }
StInspectorSlotNode >> errorMessage [
	^ 'error obtaining attribute value'
]

{ #category : #accessing }
StInspectorSlotNode >> inspectorActionsForNode [
	"Return a collection of available inspector actions associated with a variable node"

	^ self browsingActionsForNode
]

{ #category : #accessing }
StInspectorSlotNode >> key [
	^ self slot name
]

{ #category : #accessing }
StInspectorSlotNode >> rawValue [
	^ self hostObject readSlot: slot
]

{ #category : #actions }
StInspectorSlotNode >> save: anObject [
	self hostObject writeSlot: self slot value: anObject
]

{ #category : #accessing }
StInspectorSlotNode >> slot [
	^ slot
]

{ #category : #accessing }
StInspectorSlotNode >> slot: aSlot [

	self
		assert: [ aSlot isNotNil ]
		description: [ 'Slot can not be nil' ].

	slot := aSlot.
]

{ #category : #accessing }
StInspectorSlotNode >> variableTag [
	^ 'attribute'
]
