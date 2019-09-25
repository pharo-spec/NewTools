Extension { #name : #StInspectorModel }

{ #category : #'*NewTools-Debugger' }
StInspectorModel >> asDebuggerInspectorModel [

	^ StDebuggerInspectorModel on: inspectedObject
]
