"
I am a debugger extension visitor that is used to display in the debugger inspector variables that were added via debugger extensions.
"
Class {
	#name : #StDebuggerExtensionInspectorNodeBuilderVisitor,
	#superclass : #StDebuggerExtensionVisitor,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #initialization }
StDebuggerExtensionInspectorNodeBuilderVisitor >> initializeResult [

	result := OrderedCollection new
]
