Class {
	#name : #StContextInspection,
	#superclass : #StRawInspection,
	#category : #'NewTools-Inspector-View'
}

{ #category : #initialization }
StContextInspection >> initialize [ 

	super initialize.
	self title: 'Context'
]

{ #category : #initialization }
StContextInspection >> initializeWidgets [
	
	super initializeWidgets.
			
	attributeTable 
		roots: self model allInspectorNodes;
		children: [ :node | node children ]
]
