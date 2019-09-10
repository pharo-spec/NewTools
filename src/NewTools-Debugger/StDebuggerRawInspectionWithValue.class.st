Class {
	#name : #StDebuggerRawInspectionWithValue,
	#superclass : #StDebuggerRawInspection,
	#category : #'NewTools-Debugger-View'
}

{ #category : #initialization }
StDebuggerRawInspectionWithValue >> initializeWidgets [

	super initializeWidgets.
	attributeTable 
		showColumnHeaders;
		addColumn: (SpStringTableColumn 
			title: 'Value' 
			evaluated: [ :each | each gtDisplayString ])
]
