Class {
	#name : #FBByScopePagePresenter,
	#superclass : #FBPagePresenter,
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

	scopesList
		whenSelectionChangedDo: [ :selection | 
			locationsTable
				items: (locationsByScope at: selection selectedItem);
				selectIndex: 1 ];
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
