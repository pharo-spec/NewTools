Class {
	#name : 'StMethodBrowserToolbarPresenter',
	#superclass : 'StMethodToolbarPresenter',
	#instVars : [
		'flipAction',
		'scopeList'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'initialization' }
StMethodBrowserToolbarPresenter >> connectPresenters [

	scopeList whenSelectedItemChangedDo: [ : scopeEnvironment | 
		scopeEnvironment ifNotNil: [ messageList switchScopeTo: scopeEnvironment ] ].
	
	messageList whenSelectedDo: [ : item |
		item ifNotNil: [
			messageList updateVisitedScopesFrom: item.
			scopeList disableSelectionDuring: [ scopeList items: messageList allScopes ] ] ]

]

{ #category : 'layout' }
StMethodBrowserToolbarPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		spacing: 3;
		borderWidth: 3;
		add: (SpBoxLayout newTopToBottom
				vAlignCenter;
				add: scopeList;
				yourself)
			expand: false;
		add: toolbarPresenter;
		add: (SpBoxLayout newTopToBottom
				vAlignCenter;
				add: dropList;
				yourself)
			expand: false;
		yourself
]

{ #category : 'actions' }
StMethodBrowserToolbarPresenter >> doFlipLayout [

	flipAction ifNil: [ ^ self ].
	flipAction value
]

{ #category : 'initialization' }
StMethodBrowserToolbarPresenter >> initializePresenters [

	super initializePresenters.
	
	scopeList := self newDropList
		addStyle: 'stMessageBrowserScopeList';
		display: [ : item | item description ];
		yourself.
	
	toolbarPresenter add: (self newToolbarButton
		label: 'Flip';
		action: [ self doFlipLayout ]).

]

{ #category : 'accessing' }
StMethodBrowserToolbarPresenter >> owner: aPresenter [

	super owner: aPresenter.
	messageList := aPresenter methodList
]

{ #category : 'events' }
StMethodBrowserToolbarPresenter >> whenFlipLayoutDo: aBlock [

	flipAction := aBlock
]
