"
A MethodToolbar is xxxxxxxxx.

self example
"
Class {
	#name : 'StMethodToolbarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'method',
		'browseButton',
		'usersButton',
		'sendersButton',
		'implementorsButton',
		'versionButton',
		'dropList',
		'toolbarPresenter',
		'messageList'
	],
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
}

{ #category : 'examples' }
StMethodToolbarPresenter class >> example [

	<sampleInstance>
	| example |
	
	example := self new.
	example
		method: SpButtonPresenter >> #state:;
		method: nil;
		extent: 550 @ 100;
		open.
	^ example
]

{ #category : 'specs' }
StMethodToolbarPresenter class >> title [

	^ 'Toolbar'
]

{ #category : 'accessing' }
StMethodToolbarPresenter >> addItemLabeled: aString do: aBlock [
	| item |

	item := SpDropListItem on: aString do: aBlock.
	item display: [ :itemLabel | itemLabel ].
	dropList items: (dropList items copyWith: item)
]

{ #category : 'layout' }
StMethodToolbarPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		spacing: 3;
		borderWidth: 3;
		add: toolbarPresenter;
		add: (SpBoxLayout newTopToBottom
				vAlignCenter;
				add: dropList;
				yourself)
			expand: false;
		yourself
]

{ #category : 'private - actions' }
StMethodToolbarPresenter >> doBrowseImplementors [

	messageList doBrowseImplementors
]

{ #category : 'private - actions' }
StMethodToolbarPresenter >> doBrowseMethod [

	messageList doBrowseMethod
]

{ #category : 'private - actions' }
StMethodToolbarPresenter >> doBrowseSenders [

	messageList doBrowseSenders
]

{ #category : 'private - actions' }
StMethodToolbarPresenter >> doBrowseUsers [

	messageList doBrowseUsers
]

{ #category : 'private - actions' }
StMethodToolbarPresenter >> doBrowseVersions [

	messageList doBrowseVersions
]

{ #category : 'accessing' }
StMethodToolbarPresenter >> emptyDropList [
	
	dropList emptyList
]

{ #category : 'initialization' }
StMethodToolbarPresenter >> initializePresenters [

	(browseButton := self newToolbarButton)
		label: 'Browse'; 
		icon: (self iconNamed: #smallSystemBrowser);
		help: 'Browse current selected method';
		action: [ self doBrowseMethod ].
	(usersButton := self newToolbarButton) 
		label: 'References'; 
		icon: (self iconNamed: #smallFind);
		help: 'Browse references of current selected class';
		action: [ self doBrowseUsers ].
	(sendersButton := self newToolbarButton) 
		label: 'Senders'; 
		icon: (self iconNamed: #smallFind);
		help: 'Browse senders of current selected method';
		action: [ self doBrowseSenders ].
	(implementorsButton := self newToolbarButton) 
		label: 'Implementors'; 
		icon: (self iconNamed: #smallFind);
		help: 'Browse implementors of current selected method';
		action: [ self doBrowseImplementors ].
	(versionButton := self newToolbarButton) 
		label: 'Versions'; 
		icon: (self iconNamed: #history);
		help: 'Browse versions of current selected method';
		action: [ self doBrowseVersions ].
		
 	toolbarPresenter := self newToolbar
		displayMode: self application toolbarDisplayMode;
		add: browseButton;
		add: usersButton;
		add: sendersButton;
		add: implementorsButton;
		add: versionButton;
		yourself.
		
	dropList := self newDropList
		display: [ :item | item label ];
		whenSelectedItemChangedDo: [ :item | item value ];
		yourself
]

{ #category : 'accessing' }
StMethodToolbarPresenter >> messageList: aPresenter [

	messageList := aPresenter
]

{ #category : 'accessing' }
StMethodToolbarPresenter >> method [
	^ method
]

{ #category : 'accessing' }
StMethodToolbarPresenter >> method: aMethod [

	method := aMethod
]

{ #category : 'accessing' }
StMethodToolbarPresenter >> replaceVersionWithLabel: aString action: aBlock [

	versionButton 
		label: aString;
		action: aBlock
]

{ #category : 'accessing' }
StMethodToolbarPresenter >> selectFirst [

	dropList selectIndex: 1
]

{ #category : 'initialization' }
StMethodToolbarPresenter >> setModelBeforeInitialization: aMethod [

	self method: aMethod
]
