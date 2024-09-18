Class {
	#name : 'StMessageToolbarPresenter',
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
StMessageToolbarPresenter >> connectPresenters [

	scopeList whenSelectedItemChangedDo: [ :item | 
		item ifNotNil: [ messageList switchScopeTo: item ] ]
]

{ #category : 'layout' }
StMessageToolbarPresenter >> defaultLayout [

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
StMessageToolbarPresenter >> doFlipLayout [

	flipAction ifNil: [ ^ self ].
	flipAction value
]

{ #category : 'initialization' }
StMessageToolbarPresenter >> initializePresenters [

	super initializePresenters.
	
	scopeList := self newDropList
		addStyle: 'stMessageBrowserScopeList';
		display: [ : item | item description ];
		yourself.
	
	toolbarPresenter add: (self newToolbarButton
		label: 'Flip';
		action: [ self doFlipLayout ]).
		
	messageList whenSelectionChangedDo: [ : item |
		item selectedItem ifNotNil: [ : realItem | 
			scopeList items: messageList scopes ] ]
]

{ #category : 'accessing' }
StMessageToolbarPresenter >> owner: aPresenter [

	super owner: aPresenter.
	messageList := aPresenter messageList.
]

{ #category : 'events' }
StMessageToolbarPresenter >> whenFlipLayoutDo: aBlock [

	flipAction := aBlock
]
