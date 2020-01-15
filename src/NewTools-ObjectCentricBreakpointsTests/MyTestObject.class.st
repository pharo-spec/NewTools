Class {
	#name : #MyTestObject,
	#superclass : #Object,
	#instVars : [
		'ivar'
	],
	#category : #'NewTools-ObjectCentricBreakpointsTests'
}

{ #category : #'as yet unclassified' }
MyTestObject >> m1 [
	^'m1'
]

{ #category : #'as yet unclassified' }
MyTestObject >> m2 [
	^'m2'
]

{ #category : #'as yet unclassified' }
MyTestObject >> m3 [
	self m1.
	^0
]
