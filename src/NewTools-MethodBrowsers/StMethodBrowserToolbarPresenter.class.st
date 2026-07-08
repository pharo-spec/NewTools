Class {
	#name : 'StMethodBrowserToolbarPresenter',
	#superclass : 'StMethodToolbarPresenter',
	#instVars : [
		'flipAction',
		'scopeList',
		'savedScope'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'initialization' }
StMethodBrowserToolbarPresenter >> connectPresenters [

	scopeList whenSelectedItemChangedDo: [ :scopeEnvironment |
			savedScope := scopeEnvironment.
			scopeEnvironment ifNotNil: [ messageList switchScopeTo: scopeEnvironment ].
			messageList listPresenter listSize > 0 ifTrue: [ self defer: [ messageList selectIndex: 1 ] ] ].

	messageList whenSelectedDo: [ :item |
			item ifNotNil: [
					messageList updateVisitedScopesForMethod: item.
					scopeList disableSelectionDuring: [ scopeList items: messageList allScopes ].
					savedScope ifNotNil: [
							| match |
							match := scopeList items detect: [ :s | s label = savedScope label ] ifNone: [ nil ].
							match ifNotNil: [ scopeList disableSelectionDuring: [ scopeList selectItem: match ] ] ] ] ].
	scopeList items: messageList allScopes
]

{ #category : 'private' }
StMethodBrowserToolbarPresenter >> currentScope [

	^ savedScope
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
		             display: [ :item |
				             (item respondsTo: #description)
					             ifTrue: [ item description ]
					             ifFalse: [ item printString ] ];
		             yourself.

	toolbarPresenter add: (self newToolbarButton
			 label: 'Flip';
			 icon: (self iconNamed: #refreshCircling);
			 action: [ self doFlipLayout ])
]

{ #category : 'accessing' }
StMethodBrowserToolbarPresenter >> owner: aPresenter [

	super owner: aPresenter.
	messageList := aPresenter methodList
]

{ #category : 'accessing' }
StMethodBrowserToolbarPresenter >> scopeList [

	^ scopeList
]

{ #category : 'events' }
StMethodBrowserToolbarPresenter >> whenFlipLayoutDo: aBlock [

	flipAction := aBlock
]
