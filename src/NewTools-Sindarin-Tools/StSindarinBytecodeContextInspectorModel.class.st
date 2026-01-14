Class {
	#name : 'StSindarinBytecodeContextInspectorModel',
	#superclass : 'StInspectorModel',
	#category : 'NewTools-Sindarin-Tools-Model',
	#package : 'NewTools-Sindarin-Tools',
	#tag : 'Model'
}

{ #category : 'accessing' }
StSindarinBytecodeContextInspectorModel >> allModelInspectorNodes [
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

	^ self inspectedObject temporaryVariableNames collect: [ :arg1 |
		  (StInspectorTempNode hostObject: self inspectedObject) tempName: arg1 ]
]

{ #category : 'accessing' }
StSindarinBytecodeContextInspectorModel >> stacktopNode [
	^ StInspectorStackTopNode hostObject: self inspectedObject
]
