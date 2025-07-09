Class {
	#name : 'StPulseTest',
	#superclass : 'TestCase',
	#instVars : [
		'pulse'
	],
	#category : 'NewTools-Pulse-Tests',
	#package : 'NewTools-Pulse-Tests'
}

{ #category : 'running' }
StPulseTest >> setUp [
	
	super setUp.
	pulse := StPulse new
]

{ #category : 'running' }
StPulseTest >> tearDown [
	
	pulse := nil.
	super tearDown
]

{ #category : 'running' }
StPulseTest >> testDefaultKeyboardFocus [

	| window |
	[ 
		window := pulse open.
		self
			assert: pulse defaultKeyboardFocus
			equals: pulse listPresenter
	 ] ensure: [ window close ]
]

{ #category : 'running' }
StPulseTest >> testSearchingAllTypeOfCandidates [

	| window candidates |	
	[ 
		window := pulse open.
		candidates := pulse model candidatesFor: 'Test' inContext: pulse environmentContext.
		self assert: (candidates atWrap: 1) categoryLabel equals: 'class'.
		
		candidates := pulse model candidatesFor: 'test' inContext: pulse environmentContext.
		self assert: (candidates atWrap: 1) categoryLabel equals: 'method'.
		
		candidates := pulse model candidatesFor: 'NewTools' inContext: pulse environmentContext.
		self assert: (candidates atWrap: 1) categoryLabel equals: 'package'.
		
		candidates := pulse model candidatesFor: '' inContext: pulse windowsContext.
		self assert: (candidates atWrap: 1) categoryLabel equals: 'window'.
		
		candidates := pulse model candidatesFor: '' inContext: pulse toolsContext.
		self assert: (candidates atWrap: 1) categoryLabel equals: 'menu'	
	] ensure: [ window close ]
]

{ #category : 'running' }
StPulseTest >> testSearchingCandidates [

	| window candidates |
	[ 
		window := pulse open.
		candidates := pulse model candidatesFor: 'Test' inContext: pulse environmentContext.
		self assert: candidates size equals: 25.	
	] ensure: [ window close ]
]

{ #category : 'running' }
StPulseTest >> testSearchingInexistentCandidate [

	| window candidates |
	[ 
		window := pulse open.
		candidates := pulse model candidatesFor: 'ClassThatDoesntExist' inContext: pulse environmentContext.
		self assert: candidates size equals: 0.	
	] ensure: [ window close ]
]

{ #category : 'running' }
StPulseTest >> testSmoke [

	| window |
	[ self shouldnt: [ 
		SpWindowForceOpenNonModal during: [  window := StPulse open ] ] raise: Error ] ensure: [ window close ].

	[ self shouldnt: [ SpWindowForceOpenNonModal during: [ window := StPulse openWithTextOnEnvironment: '1' ] ] 
		raise: Error ] ensure: [ window close ].

	[ self shouldnt: [ 
		SpWindowForceOpenNonModal during: [ window := StPulse openWithTextOnWindows: '2' ] ]
		raise: Error ] ensure: [ window close ].

	[ self shouldnt: [ 
		SpWindowForceOpenNonModal during: [ window := StPulse openWithTextOnCommands: '3' ] ] 
		raise: Error ] ensure: [ window close ]
]
