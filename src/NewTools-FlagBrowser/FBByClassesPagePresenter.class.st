"
Description
--------------------

I am a presenter showing the flags in classes.
"
Class {
	#name : 'FBByClassesPagePresenter',
	#superclass : 'FBByScopePagePresenter',
	#category : 'NewTools-FlagBrowser-Presenters',
	#package : 'NewTools-FlagBrowser',
	#tag : 'Presenters'
}

{ #category : 'specs' }
FBByClassesPagePresenter class >> icon [
	^ #class
]

{ #category : 'accessing' }
FBByClassesPagePresenter class >> priority [
	^ 10
]

{ #category : 'specs' }
FBByClassesPagePresenter class >> title [
	^ 'By class'
]

{ #category : 'initialization' }
FBByClassesPagePresenter >> initializeWidgets [
	super initializeWidgets.

	locationsTable
		addColumn: (SpStringTableColumn title: 'Method' evaluated: #selector);
		addColumn: (SpStringTableColumn title: 'Flag parameter' evaluated: [ :location | location owner parameter ])
]

{ #category : 'initialization' }
FBByClassesPagePresenter >> scopeSelector [
	^ #classLocation
]
