"
Description
--------------------

I am a presenter showing the flags in packages.
"
Class {
	#name : 'FBByPackagesPagePresenter',
	#superclass : 'FBByScopePagePresenter',
	#category : 'NewTools-FlagBrowser-Presenters',
	#package : 'NewTools-FlagBrowser',
	#tag : 'Presenters'
}

{ #category : 'specs' }
FBByPackagesPagePresenter class >> icon [
	^ #package
]

{ #category : 'accessing' }
FBByPackagesPagePresenter class >> priority [
	^ 5
]

{ #category : 'specs' }
FBByPackagesPagePresenter class >> title [
	^ 'By package'
]

{ #category : 'initialization' }
FBByPackagesPagePresenter >> initializeWidgets [
	super initializeWidgets.

	locationsTable
		addColumn: (SpStringTableColumn title: 'Class' evaluated: #classLocation);
		addColumn: (SpStringTableColumn title: 'Method' evaluated: #selector);
		addColumn: (SpStringTableColumn title: 'Flag parameter' evaluated: [ :location | location owner parameter ])
]

{ #category : 'initialization' }
FBByPackagesPagePresenter >> scopeSelector [
	^ #package
]
