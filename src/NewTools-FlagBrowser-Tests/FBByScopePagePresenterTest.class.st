Class {
	#name : #FBByScopePagePresenterTest,
	#superclass : #FBFlagPresentationPresenterTest,
	#category : #'NewTools-FlagBrowser-Tests-Presenters'
}

{ #category : #testing }
FBByScopePagePresenterTest class >> isAbstract [
	^ self = FBByScopePagePresenterTest 
]

{ #category : #'as yet unclassified' }
FBByScopePagePresenterTest >> assertionSubClassResponsability [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
FBByScopePagePresenterTest >> itemToTest [
	^ self subclassResponsibility.
]

{ #category : #tests }
FBByScopePagePresenterTest >> testWhenScopeChangeShouldTransmitLocationTable [
	flagPage scopesList selectIndex: (flagPage scopesList items  indexOf: self itemToTest  ).
	self assertionSubClassResponsability.
]
