"
Description
--------------------

I am a presenter showing the flags in packages.
"
Class {
	#name : #FBByPackagesPagePresenter,
	#superclass : #FBByScopePagePresenter,
	#category : #'FlagBrowser-Spec'
}

{ #category : #specs }
FBByPackagesPagePresenter class >> icon [
	^ #package
]

{ #category : #accessing }
FBByPackagesPagePresenter class >> priority [
	^ 5
]

{ #category : #specs }
FBByPackagesPagePresenter class >> title [
	^ 'By package'
]

{ #category : #initialization }
FBByPackagesPagePresenter >> initializeWidgets [
	super initializeWidgets.

	locationsTable
		addColumn: (StringTableColumn title: 'Class' evaluated: #classLocation);
		addColumn: (StringTableColumn title: 'Method' evaluated: #selector);
		addColumn: (StringTableColumn title: 'Flag parameter' evaluated: [ :location | location flag parameter ])
]

{ #category : #initialization }
FBByPackagesPagePresenter >> scopeSelector [
	^ #package
]
