"
I allow to easily create trees (instances of ScopeTreePresenter) to display scopes (as roots) and scopes (as roots)
"
Class {
	#name : 'ScopeAbstractPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model'
	],
	#category : 'NewTools-Scopes-Editor-GUI',
	#package : 'NewTools-Scopes-Editor',
	#tag : 'GUI'
}

{ #category : 'accessing' }
ScopeAbstractPresenter >> announcer [ 
	^ model announcer
]

{ #category : 'actions' }
ScopeAbstractPresenter >> getNameFromUser [

	^ (ScopeRequestLabel newApplication: self application)
		  title: 'Scope name...';
		  validateAnswer: [ :txt |
			  | isValid |
			  isValid := self validateNameBlock value: txt.
			  isValid ifFalse: [
					  isValid ifFalse: [
							  self inform: 'Name can''t be empty or contain spaces' ] ].
			  isValid ];
		  onAccept: [ :dialog | dialog close ];
		  extent: 250 @ 150;
		  openModal
]

{ #category : 'private - presenters' }
ScopeAbstractPresenter >> newScopeTree [

	^ self instantiate: ScopeTreePresenter
]

{ #category : 'private - presenters' }
ScopeAbstractPresenter >> setModelBeforeInitialization: aScopesManager [

	model := aScopesManager 
]

{ #category : 'menu commands' }
ScopeAbstractPresenter >> showReferencesToClass: aClass [

	| scope browser query class |
	class := aClass.
	scope := ClySystemEnvironmentScope
		         of: ClySystemEnvironment currentImage
		         in: ClyNavigationEnvironment currentImage.

	browser := (ClyFullBrowserMorph on:
		            ClyNavigationEnvironment currentImage)
		           ensureInitialState.

	query := (ClyClassReferencesQuery of: class)
		         scope: scope;
		         yourself.

	browser spawnQueryBrowserOn: query
]

{ #category : 'private' }
ScopeAbstractPresenter >> validateNameBlock [

	^ [ :txt |
	  | isValid |
	  isValid := txt isNotNil and: [
		             txt isNotEmpty and: [ (txt includesSubstring: ' ') not ] ].
	  isValid ]
]
