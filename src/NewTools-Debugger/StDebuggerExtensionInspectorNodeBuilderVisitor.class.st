"
I am a debugger extension visitor that is used to display in the debugger inspector variables that were added via debugger extensions.
"
Class {
	#name : #StDebuggerExtensionInspectorNodeBuilderVisitor,
	#superclass : #StDebuggerExtensionVisitor,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'instance creation' }
StDebuggerExtensionInspectorNodeBuilderVisitor >> newCollection [

	^ #(  ) asOrderedCollection
]

{ #category : #visiting }
StDebuggerExtensionInspectorNodeBuilderVisitor >> visit: aStDebuggerExtension [

	| extensionNodes |
	extensionNodes := super visit: aStDebuggerExtension.
	"If the visit hook that is used does nothing, then we return an empty collection"
	^ extensionNodes == self ifTrue: [ self newCollection ] ifFalse: [ extensionNodes ]
]

{ #category : #visiting }
StDebuggerExtensionInspectorNodeBuilderVisitor >> visitChest: aChestExtension [

	| debuggerInteractionModel  |
	debuggerInteractionModel := aChestExtension debugger code
		                            interactionModel.
	^ debuggerInteractionModel bindings associations
		  select: [ :aBinding | 
			  aBinding propertyAt: #comesFromChest ifAbsent: [ false ] ]
		  thenCollect: [ :chestVariable | 
			  (StInspectorDynamicNode
				   hostObject: chestVariable value
				   label: chestVariable key
				   value: chestVariable value)
				  variableTag: 'Chest';
				  yourself ]
]
