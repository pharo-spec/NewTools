Class {
	#name : #ObjectCentricHaltTest,
	#superclass : #TestCase,
	#instVars : [
		'object1',
		'object2'
	],
	#category : #'NewTools-ObjectCentricBreakpointsTests'
}

{ #category : #running }
ObjectCentricHaltTest >> setUp [
	object1 := MyTestObject new.
	object2 := MyTestObject new
]

{ #category : #running }
ObjectCentricHaltTest >> tearDown [
	MetaLink uninstallAll
]
