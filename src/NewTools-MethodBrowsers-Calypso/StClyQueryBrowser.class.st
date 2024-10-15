"
A spec based query browser.
Show in one table result of a system query.

To show query use following method: 

	StClyQueryBrowser openOn: (ClyMessageSenders of: #do:)

I implement more simple API on class side: 

	StClyQueryBrowser browseSendersOf: #do:.
	StClyQueryBrowser browseImplementorsOf: #do:.
	StClyQueryBrowser browseMethods: {Point>>#x. Point>>#y}.

Last method is suitable to show given list of methods. But normally users should use first class queries.

I provide scoping mechanizm: user can filter query result using scopes from the compobox in toolbar.

When I spawned from the browser I receive all its navigation scopes.
For full browser I receive current selection package and class scopes.
For query browser I inherit all scopes which it has.
Also I add extra scopes to my scope list which is based on my current selection.
For example selected method will bring extra class and package scopes of this method.  
"
Class {
	#name : 'StClyQueryBrowser',
	#superclass : 'StComposedMessageBrowser',
	#instVars : [
		'navigationHistory',
		'navigationEnvironment',
		'systemScope',
		'queryScopes',
		'systemQuery',
		'activeScope'
	],
	#classVars : [
		'DefaultQueryResult'
	],
	#category : 'NewTools-MethodBrowsers-Calypso',
	#package : 'NewTools-MethodBrowsers-Calypso'
}

{ #category : 'tools registration' }
StClyQueryBrowser class >> beDefaultBrowser [
	<script>

	^ StClyOldMessageBrowserAdapter beDefaultBrowser
]

{ #category : 'instance creation' }
StClyQueryBrowser class >> browseImplementorsOf: aSymbol inNameResolver: methodContext [

	^ self openOn: (ClyMessageImplementorsQuery of: aSymbol)
]

{ #category : 'instance creation' }
StClyQueryBrowser class >> browseMethods: methods [

	^ self openOn: (ClyConstantMethodQuery with: methods)
]

{ #category : 'instance creation' }
StClyQueryBrowser class >> browseSendersOf: aSymbol [

	^ self openOn: (ClyMessageSendersQuery of: aSymbol)
]

{ #category : 'default' }
StClyQueryBrowser class >> defaultQueryResult [

	^ DefaultQueryResult ifNil: [
		DefaultQueryResult := ClyHierarchicalSystemItemsResult new ]
]

{ #category : 'instance creation' }
StClyQueryBrowser class >> on: navigationEnvironment [

	^ self basicNew
		application: self currentApplication;
		navigationEnvironment: navigationEnvironment;
		initialize;
		yourself
]

{ #category : 'instance creation' }
StClyQueryBrowser class >> on: aNavigationEnvironment scopes: scopes [

	^(self on: aNavigationEnvironment) queryScopes: scopes
]

{ #category : 'instance creation' }
StClyQueryBrowser class >> on: navigationEnvironment systemScope: systemScope [

	^ (self on: navigationEnvironment)
		systemScope: systemScope;
		initialize;
		yourself
]

{ #category : 'instance creation' }
StClyQueryBrowser class >> openOn: aQuery [
	| browser |
	
	browser := self on: ClyNavigationEnvironment currentImage.
	browser showResultOf: aQuery.
	^ browser open
]

{ #category : 'icons' }
StClyQueryBrowser class >> taskbarIconName [
	"Answer the icon for an instance of the receiver in a task bar"

	^ #references
]

{ #category : 'accessing' }
StClyQueryBrowser >> changeStateBy: aBlock [
	
	aBlock value.
	self updateWindowTitle
]

{ #category : 'accessing' }
StClyQueryBrowser >> disablePluginsWhichAreNotIn: aClyFullBrowser [
	"do nothing for now"
]

{ #category : 'initialization' }
StClyQueryBrowser >> initialize [

	queryScopes := OrderedCollection new.
	navigationHistory := ClyNavigationHistory new.
	super initialize
]

{ #category : 'accessing' }
StClyQueryBrowser >> navigationEnvironment [

	^ navigationEnvironment
]

{ #category : 'initialization' }
StClyQueryBrowser >> navigationEnvironment: aNavigationEnvironment [

	navigationEnvironment := aNavigationEnvironment
]

{ #category : 'initialization' }
StClyQueryBrowser >> newMessageList [

	^ (self instantiate: StClyMessageListPresenter)
		navigationEnvironment: self navigationEnvironment;
		yourself
]

{ #category : 'accessing' }
StClyQueryBrowser >> prepareInitialStateBy: aBlock [
	
	navigationHistory ignoreNavigationDuring: [  
		aBlock valueWithPossibleArgument: self ]
]

{ #category : 'accessing' }
StClyQueryBrowser >> queryScopes: aCollection [

	queryScopes := (aCollection
		reject: [ :each | each isBasedOnEmptyBasis ])
		as: OrderedCollection.
		
	messageList scopes: queryScopes.
	
	self updatePresenter
]

{ #category : 'navigation' }
StClyQueryBrowser >> recordNavigationState: aBrowserNavigationState [

	navigationHistory recordState: aBrowserNavigationState
]

{ #category : 'execution' }
StClyQueryBrowser >> requiredQueryResult [

	^systemQuery
		ifNil: [ self class defaultQueryResult ]
		ifNotNil: [ systemQuery requiredResult ]
]

{ #category : 'selection' }
StClyQueryBrowser >> selectLastItem [
	
	messageList listPresenter selectIndex: messageList listPresenter items size
]

{ #category : 'accessing' }
StClyQueryBrowser >> setUpActiveScope [

	systemQuery isBoundToEnvironment 
		ifFalse: [ systemQuery := systemQuery withScope: self systemScope ].
	(queryScopes includes: systemQuery scope) 
		ifFalse: [ queryScopes add: systemQuery scope ].
	activeScope := systemQuery scope
]

{ #category : 'accessing' }
StClyQueryBrowser >> showQueryResult [
	"self showsFlatResult ifTrue: [
		""Browser keeps flat query result in variable
		to be able switch back to it later from hierarchy mode""
		expectedFlatQueryResult := systemQuery requiredResult ]."

	self setUpActiveScope.
	highlight := systemQuery highlightElement.
	messageList 
		query: systemQuery;
		scopes: { systemScope };
		updateMessages.
	toolbarPresenter updatePresenter
]

{ #category : 'accessing' }
StClyQueryBrowser >> showResultOf: aQuery [
	"If given query has specific result then browser will show it as requested.
	Otherwise it will force query to build currently configured required result
	(when given query has no explicitly specified result which means it has only default value)"

	self changeStateBy: [
		systemQuery := aQuery buildsDefaultResult
			ifTrue: [ aQuery withResult: self requiredQueryResult ]
			ifFalse: [ aQuery ].
		self showQueryResult ]
]

{ #category : 'accessing' }
StClyQueryBrowser >> systemScope [
	
	^ systemScope ifNil: [ systemScope := navigationEnvironment systemScope ]
]

{ #category : 'accessing' }
StClyQueryBrowser >> systemScope: aSystemScope [

	systemScope := aSystemScope
]

{ #category : 'initialization' }
StClyQueryBrowser >> updatePresenter [

	super updatePresenter.
	messageList updatePresenter.
	toolbarPresenter updatePresenter
]

{ #category : 'activation' }
StClyQueryBrowser >> updateWindowTitle [
	
	self title: systemQuery description
]

{ #category : 'accessing' }
StClyQueryBrowser >> wasSpawnedFrom: aBrowser [

	self recordNavigationState: (ClyAccrossWindowNavigationState from: aBrowser)
]
