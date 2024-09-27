Class {
	#name : 'StClyMessageListPresenter',
	#superclass : 'StComposedMessageListPresenter',
	#instVars : [
		'scopes',
		'query',
		'navigationEnvironment'
	],
	#category : 'NewTools-MethodBrowsers-Calypso',
	#package : 'NewTools-MethodBrowsers-Calypso'
}

{ #category : 'private' }
StClyMessageListPresenter >> allNavigationScopes [
	| extraScopes |
	
	scopes ifNil: [ scopes := #() ].
	extraScopes := self extraScopesOfSelectedItems reject: #isBasedOnEmptyBasis.
	^ scopes, (extraScopes copyWithoutAll: scopes)
]

{ #category : 'private' }
StClyMessageListPresenter >> classScopeOfSelectedItems [
	| classes |
	
	classes := { self selectedMessageOrFirst methodClass }.
	^ ClyBothMetaLevelClassScope ofAll: classes in: navigationEnvironment
]

{ #category : 'initialization' }
StClyMessageListPresenter >> connectPresenters [

	listPresenter whenSelectedItemChangedDo: [ :item | self updateScopeList ] 
]

{ #category : 'private - actions' }
StClyMessageListPresenter >> doRemoveMethod [

	(ReRemoveMethodDriver new
		scopes: self scopes
		methods: { self selectedMethod }) 
		runRefactoring	
]

{ #category : 'private' }
StClyMessageListPresenter >> extraScopesOfSelectedItems [
	| classScope |
	
	classScope := self classScopeOfSelectedItems.
	^{
		self packageScopeOfSelectedItems.
		classScope asFullHierarchyScope.
		classScope
	}, ScopesManager availableScopes
]

{ #category : 'accessing' }
StClyMessageListPresenter >> navigationEnvironment [

	^ navigationEnvironment
]

{ #category : 'accessing' }
StClyMessageListPresenter >> navigationEnvironment: anEnvironment [

	navigationEnvironment := anEnvironment
]

{ #category : 'private' }
StClyMessageListPresenter >> packageScopeOfSelectedItems [
	| packages |
	
	packages := { self selectedMessageOrFirst package }.
	^ ClyPackageScope ofAll: packages in: navigationEnvironment
]

{ #category : 'accessing' }
StClyMessageListPresenter >> query [

	^ query
]

{ #category : 'accessing' }
StClyMessageListPresenter >> query: aQuery [

	query := aQuery
]

{ #category : 'accessing' }
StClyMessageListPresenter >> scopes [

	^ scopes
]

{ #category : 'accessing' }
StClyMessageListPresenter >> scopes: aCollectionOfScopes [

	scopes := aCollectionOfScopes
]

{ #category : 'private' }
StClyMessageListPresenter >> selectedMessageOrFirst [

	^ listPresenter selection selectedItem 
		ifNil: [ 
			listPresenter items 
				ifNotEmpty: [ :items | items first ]
				ifEmpty: [ nil ] ]
]

{ #category : 'updating' }
StClyMessageListPresenter >> switchScopeTo: aScope [

	query ifNil: [ ^ self ].
	query := query withScope: aScope.
	self updateMessages
]

{ #category : 'updating' }
StClyMessageListPresenter >> updateMessages [

	self messages: (self query execute items collect: [ :each | each actualObject ])
]

{ #category : 'updating' }
StClyMessageListPresenter >> updateScopeList [

	self selectedMessageOrFirst ifNil: [ ^ self ].
	self scopes: self allNavigationScopes
]
