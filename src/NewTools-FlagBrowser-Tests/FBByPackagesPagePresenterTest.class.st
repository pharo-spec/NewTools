Class {
	#name : #FBByPackagesPagePresenterTest,
	#superclass : #FBByScopePagePresenterTest,
	#category : #'NewTools-FlagBrowser-Tests-Presenters'
}

{ #category : #'as yet unclassified' }
FBByPackagesPagePresenterTest >> assertionSubClassResponsability [
	self assert: (flagPage locationsTable items collect: #selector) equals: { 'methodTaged' . 'flaged' } asOrderedCollection 
]

{ #category : #running }
FBByPackagesPagePresenterTest >> instanciateFlagPage [
	^ FBByPackagesPagePresenter new
]

{ #category : #'as yet unclassified' }
FBByPackagesPagePresenterTest >> itemToTest [
	^ 'NewTools-FlagBrowser-extraUseForTest' asPackage 
]
