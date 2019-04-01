"
Description
--------------------

I am a presenter showing the flags in a scope.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	scopesList:		<aListPresenter>	The list of scopes the user can select.

"
Class {
	#name : #FBByScopePagePresenter,
	#superclass : #FBFlagPresentationPresenter,
	#instVars : [
		'scopesList'
	],
	#category : #'FlagBrowser-Spec'
}

{ #category : #specs }
FBByScopePagePresenter class >> defaultSpec [
	^ SpecPanedLayout newHorizontal
		position: 250;
		add: #scopesList;
		add:
			(SpecPanedLayout newVertical
				add: #locationsTable;
				add: #code;
				yourself);
		yourself
]

{ #category : #testing }
FBByScopePagePresenter class >> isAbstract [
	^ self = FBByScopePagePresenter
]

{ #category : #initialization }
FBByScopePagePresenter >> initializePresenter [
	| locationsByScope |
	super initializePresenter.
	locationsByScope := (FBFlag allFlags flatCollect: #locations) groupedBy: self scopeSelector.

	scopesList transmitTo: locationsTable transform: [ :scope | locationsByScope at: scope ] postTransmission: [ :destination | destination selectIndex: 1 ].

	scopesList
		items: locationsByScope keys;
		selectIndex: 1
]

{ #category : #initialization }
FBByScopePagePresenter >> initializeWidgets [
	super initializeWidgets.
	scopesList := self newList.

	scopesList
		displayBlock: #name;
		sortingBlock: #name ascending
]

{ #category : #initialization }
FBByScopePagePresenter >> scopeSelector [
	^ self subclassResponsibility
]
