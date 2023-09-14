"
A RTSearchForPanelTest is a test class for testing the behavior of RTSearchForPanel
"
Class {
	#name : #StRewriterSearchForPanelTest,
	#superclass : #TestCase,
	#instVars : [
		'searchPanel'
	],
	#category : #'NewTools-RewriterTools-Tests-Panels'
}

{ #category : #running }
StRewriterSearchForPanelTest >> setUp [

	super setUp.
	searchPanel := StRewriterSearchForPanelPresenter new
]

{ #category : #tests }
StRewriterSearchForPanelTest >> testLhs [

	searchPanel lhs: 'Some code'.
	self assert: searchPanel lhs equals: 'Some code'
]
