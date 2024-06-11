Class {
	#name : 'StSindarinBytecodeContextInspectorModel',
	#superclass : 'StInspectorModel',
	#category : 'NewTools-Sindarin-Tools',
	#package : 'NewTools-Sindarin-Tools'
}

{ #category : 'accessing' }
StSindarinBytecodeContextInspectorModel >> allInspectorNodes [
	| tempNodes slotNodes stackTopNode |
	tempNodes := self contextTempNodes.
	slotNodes := self contextReceiverSlotNodes.
	stackTopNode := self stacktopNode.
	^ OrderedCollection new
		add: stackTopNode;
		addAll: tempNodes;
		addAll: slotNodes;
		yourself
]

{ #category : 'accessing' }
StSindarinBytecodeContextInspectorModel >> contextReceiverSlotNodes [
	^ self inspectedObject receiver class allSlots
		collect: [ :each | 
			StBytecodeInspectorSlotNode
				hostObject: self inspectedObject receiver
				slot: each ]
]

{ #category : 'accessing' }
StSindarinBytecodeContextInspectorModel >> contextTempNodes [
	^ self inspectedObject astScope allTemps collect: [ :temp | 
		  (StInspectorTempNode hostObject: self inspectedObject) tempVariable: temp ]

]

{ #category : 'accessing' }
StSindarinBytecodeContextInspectorModel >> stacktopNode [
	^ StInspectorStackTopNode hostObject: self inspectedObject
]
