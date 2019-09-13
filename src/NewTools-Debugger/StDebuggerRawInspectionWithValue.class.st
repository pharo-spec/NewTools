Class {
	#name : #StDebuggerRawInspectionWithValue,
	#superclass : #StDebuggerRawInspection,
	#category : #'NewTools-Debugger-View'
}

{ #category : #building }
StDebuggerRawInspectionWithValue >> addValuesColumn [
	
	attributeTable addColumn: self valuesColumn
]

{ #category : #initialization }
StDebuggerRawInspectionWithValue >> initializePresenters [

	super initializePresenters.
	attributeTable showColumnHeaders
]
