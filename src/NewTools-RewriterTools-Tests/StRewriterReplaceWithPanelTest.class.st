"
A RTReplaceWithPanelTest is a test class for testing the behavior of RTReplaceWithPanel
"
Class {
	#name : #StRewriterReplaceWithPanelTest,
	#superclass : #TestCase,
	#instVars : [
		'replacePanel'
	],
	#category : #'NewTools-RewriterTools-Tests-Panels'
}

{ #category : #running }
StRewriterReplaceWithPanelTest >> setUp [

	super setUp.
	replacePanel := StRewriterReplaceWithPanel new
]

{ #category : #tests }
StRewriterReplaceWithPanelTest >> testRhs [

	replacePanel rhs: 'Some code'.
	self assert: replacePanel rhs equals: 'Some code'
]
