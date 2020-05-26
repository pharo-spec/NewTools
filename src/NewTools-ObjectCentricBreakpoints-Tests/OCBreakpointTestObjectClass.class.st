Class {
	#name : #OCBreakpointTestObjectClass,
	#superclass : #Object,
	#instVars : [
		'ivar',
		'ivar2'
	],
	#category : #'NewTools-ObjectCentricBreakpoints-Tests'
}

{ #category : #initialization }
OCBreakpointTestObjectClass >> initialize [
	ivar := 1.
	ivar2 := 2
]

{ #category : #'as yet unclassified' }
OCBreakpointTestObjectClass >> ivar2Read [
	^ivar2 
]

{ #category : #'as yet unclassified' }
OCBreakpointTestObjectClass >> ivar2ReadWrite [
	ivar2 := 0.
	^ivar2 
]

{ #category : #'as yet unclassified' }
OCBreakpointTestObjectClass >> ivar2Write [
	ivar2 := 0 
]

{ #category : #'as yet unclassified' }
OCBreakpointTestObjectClass >> ivarRead [ 
	^ivar 
]

{ #category : #'as yet unclassified' }
OCBreakpointTestObjectClass >> ivarReadWrite [ 
	ivar := 0.
	^ivar 
]

{ #category : #'as yet unclassified' }
OCBreakpointTestObjectClass >> ivarWrite [ 
	ivar := 0 
]

{ #category : #'as yet unclassified' }
OCBreakpointTestObjectClass >> m1 [
	^'m1'
]

{ #category : #'as yet unclassified' }
OCBreakpointTestObjectClass >> m2 [
	^'m2'
]

{ #category : #'as yet unclassified' }
OCBreakpointTestObjectClass >> m3 [
	self m1.
	^0
]

{ #category : #tests }
OCBreakpointTestObjectClass >> test [ 	
	self test2
]

{ #category : #tests }
OCBreakpointTestObjectClass >> test2 [ 	
	thisContext sender inspect
]
