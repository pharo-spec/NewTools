Class {
	#name : #OCBreakpointTestObjectClass,
	#superclass : #Object,
	#instVars : [
		'ivar'
	],
	#category : #'NewTools-ObjectCentricBreakpointsTests'
}

{ #category : #'as yet unclassified' }
OCBreakpointTestObjectClass >> ivarAccess [
	^ivar 
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
