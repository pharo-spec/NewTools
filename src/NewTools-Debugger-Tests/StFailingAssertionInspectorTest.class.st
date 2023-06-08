Class {
	#name : #StFailingAssertionInspectorTest,
	#superclass : #TestCase,
	#category : #'NewTools-Debugger-Tests-Presenters'
}

{ #category : #tests }
StFailingAssertionInspectorTest >> testDiffForNonStringObjects [
	|a e inspector|
	a := 'a'.
	e := 1.
	inspector := StFailingAssertionInspector
		diffInspectorsFromActual: a
		expected: e
		application: nil.
	self deny: inspector actualObjectMillerList equals: nil.
	self deny: inspector expectedObjectMillerList equals: nil.
	self assert: inspector stringDiff equals: nil.
	a := 4.
	e := 1.
	inspector := StFailingAssertionInspector
		diffInspectorsFromActual: a
		expected: e
		application: nil.
	self deny: inspector actualObjectMillerList equals: nil.
	self deny: inspector expectedObjectMillerList equals: nil.
	self assert: inspector stringDiff equals: nil.
]

{ #category : #tests }
StFailingAssertionInspectorTest >> testDiffForStrings [
	|a e inspector|
	a := 'a'.
	e := 'e'.
	inspector := StFailingAssertionInspector
		diffInspectorsFromActual: a
		expected: e
		application: nil.
	self deny: inspector stringDiff equals: nil.
	self assert: inspector actualObjectMillerList equals: nil.
	self assert: inspector expectedObjectMillerList equals: nil.
]

{ #category : #tests }
StFailingAssertionInspectorTest >> testDiffForSymbols [
	|actual expected inspector|
	actual := #'#east'. 
	expected := #east.
	inspector := StFailingAssertionInspector
		diffInspectorsFromActual: actual
		expected: expected
		application: nil.

	self assert: inspector stringDiff leftText equals: '#''#east'''.
	self assert: inspector stringDiff rightText equals: '#east'.
]
