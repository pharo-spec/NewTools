Class {
	#name : #FBByClassesPagePresenterTest,
	#superclass : #FBByScopePagePresenterTest,
	#category : #'NewTools-FlagBrowser-Tests-Presenters'
}

{ #category : #'as yet unclassified' }
FBByClassesPagePresenterTest >> assertionSubClassResponsability [
	self assert: (flagPage locationsTable items collect: #selector) equals: { #flaged } asOrderedCollection
]

{ #category : #running }
FBByClassesPagePresenterTest >> instanciateFlagPage [
	^ FBByClassesPagePresenter new
]

{ #category : #'as yet unclassified' }
FBByClassesPagePresenterTest >> itemToTest [
	^ UseByFlagbrowserTest
]
