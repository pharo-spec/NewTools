"
A SpClosedWindowListPresenter is a presenter that manages and displays a list of recently closed windows in the Pharo image.
It maintains a history of the last 5 closed windows and provides functionality to either
permanently close them or restore them to their previous state.

My list is holding the last 5 closed windows. 

I am using a Singleton design pattern because I'm saving the closed windows in the list of my unique instance. But I can still be opened multiple times.

Example usage:
```smalltalk
    SpClosedWindowListPresenter uniqueInstance open
```

Implementation Points:
- Uses a fixed-size ring buffer (max 5 elements) to track closed windows
- Windows can be restored to their original position and state
- Updates the list automatically when windows are closed or restored

Public API:
- #addClosedWindow: aWindow    Add a window to the history

"
Class {
	#name : 'SpClosedWindowListPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'list',
		'unhideButton',
		'removeButton',
		'unhideItemBlock',
		'removeItemBlock',
		'activateBox',
		'rejectedWindows'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : 'NewTools-WindowManager',
	#package : 'NewTools-WindowManager'
}

{ #category : 'accessing' }
SpClosedWindowListPresenter class >> defaultPreferredExtent [

	^ 310 @ 185
]

{ #category : 'accessing' }
SpClosedWindowListPresenter class >> enableCloseWindow [

	^ SystemWindow useHideForClose
]

{ #category : 'accessing' }
SpClosedWindowListPresenter class >> enableCloseWindow: aBoolean [

	aBoolean
		ifTrue: [ self subscribeToWindowClosedAnnoucements ]
		ifFalse: [ self unsubscribeToWindowClosedAnnoucements ].

	^ SystemWindow useHideForClose: aBoolean
]

{ #category : 'class initialization' }
SpClosedWindowListPresenter class >> initialize [

	SessionManager default registerUserClassNamed: self name.

]

{ #category : 'instance creation' }
SpClosedWindowListPresenter class >> new [ 
	self error: 'We should have only one instance of this presenter'
]

{ #category : 'instance creation' }
SpClosedWindowListPresenter class >> reset [

	<script>
	UniqueInstance := nil
]

{ #category : 'settings' }
SpClosedWindowListPresenter class >> settingOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #useHideForClose)
		parent: #tools;
		order: 1;
		target: self;
		selector: #enableCloseWindow;
		description:
			'If closed windows will be stored in SpClosedWindowListPresenter';
		label: 'Use last closed windows'
]

{ #category : 'system startup' }
SpClosedWindowListPresenter class >> shutDown: isImageQuitting [

	isImageQuitting ifFalse: [ ^ self ].
	self uniqueInstance items removeAll.

]

{ #category : 'events subscription' }
SpClosedWindowListPresenter class >> subscribeToWindowClosedAnnoucements [

	<script>
	self currentWorld announcer
		when: WindowClosed
		do: [ :ann | self uniqueInstance addClosedWindow: ann window ]
		for: self
]

{ #category : 'instance creation' }
SpClosedWindowListPresenter class >> uniqueInstance [

	^ UniqueInstance ifNil: [ UniqueInstance := self basicNew initialize ]
]

{ #category : 'events subscription' }
SpClosedWindowListPresenter class >> unsubscribeToWindowClosedAnnoucements [

	<script>
	self currentWorld announcer unsubscribe: self
]

{ #category : 'world menu items' }
SpClosedWindowListPresenter class >> windowMenuOn: aBuilder [

	<windowMenu>
	|  announcement |
	(aBuilder item: #Close)
		order: 1.0;
		action: [
			aBuilder model hide.
			announcement := WindowClosed new
				                window: aBuilder model;
				                yourself.
			self currentWorld announcer announce: announcement ];
		iconName: #windowCloseInactive;
		enabledBlock: [ aBuilder model allowedToClose ];
		withSeparatorAfter.
]

{ #category : 'menu items' }
SpClosedWindowListPresenter class >> windowsOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Reopen closed windows')
		parent: #Windows;
		order: 1;
		action: [ self uniqueInstance open ];
		help: 'Show the last 5 closed windows.'
]

{ #category : 'accessing' }
SpClosedWindowListPresenter >> activateBox [

	^ activateBox
]

{ #category : 'adding' }
SpClosedWindowListPresenter >> addClosedWindow: aModel [

	self items size >= 5 ifTrue: [
		5 to: self items size do: [ :i | self items removeLast close ] ].

	(self isWindowRejected: aModel)
		ifFalse: [
			aModel setProperty: #isClosed toValue: true.
			self items addFirst: aModel ]
		ifTrue: [ aModel closeBoxHit ].
	self refresh
]

{ #category : 'adding' }
SpClosedWindowListPresenter >> addRejectedWindow: aWindowClass [

	rejectedWindows add: aWindowClass
]

{ #category : 'initialization' }
SpClosedWindowListPresenter >> connectPresenters [

	super connectPresenters.

	activateBox
		whenActivatedDo: [ self enableCloseWindow: true ];
		whenDeactivatedDo: [ self enableCloseWindow: false ].
	unhideButton action: [
		| newItem |
		list items isNotEmpty ifTrue: [
			newItem := unhideItemBlock cull: self selectedItem ] ].
	removeButton action: [
		list items isNotEmpty ifTrue: [
			removeItemBlock cull: self selectedItem ] ]
]

{ #category : 'layout' }
SpClosedWindowListPresenter >> defaultLayout [

	| listLayout |
	listLayout := SpBoxLayout newLeftToRight
		              add: #list;
		              yourself.

	^ SpBoxLayout newTopToBottom
		  add: listLayout;
		  add: (SpBoxLayout newLeftToRight
				   add: activateBox expand: false;
				   addLast: #unhideButton expand: false;
				   addLast: #removeButton expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'accessing' }
SpClosedWindowListPresenter >> enableCloseWindow [
	^ self class enableCloseWindow
]

{ #category : 'accessing' }
SpClosedWindowListPresenter >> enableCloseWindow: aBoolean [

	^ self class enableCloseWindow: aBoolean
]

{ #category : 'initialization' }
SpClosedWindowListPresenter >> initialize [

	super initialize.
	removeItemBlock := [ :item |
	                   item ifNotNil: [
		                   self items remove: item.
		                   item closeBoxHit.
		                   self refresh ] ].
	unhideItemBlock := [ :item |
	                   item ifNotNil: [ item visible: true ].
	                   item removeProperty: #isClosed.
	                   self items remove: item.
	                   self refresh ].
	self initializeRejectedWindows
]

{ #category : 'initialization' }
SpClosedWindowListPresenter >> initializePresenters [

	list := self newList
		        items: OrderedCollection new;
		        whenActivatedDo: [ :selection |
			        unhideItemBlock cull: selection selectedItem ];
		        display: [ :s | s displayString ].
	activateBox := self newCheckBox
		               state: self enableCloseWindow;
		               help: 'Enable/disable the unclose window logic'.
	unhideButton := self newButton.
	removeButton := self newButton.
	unhideButton
		addStyle: 'small';
		addStyle: 'flat';
		icon: (self iconNamed: #undo);
		help: 'Unhide an item from the list'.
	removeButton
		addStyle: 'small';
		addStyle: 'flat';
		icon: (self iconNamed: #remove);
		help: 'Remove a item from the list'.
	self resetSelection
]

{ #category : 'initialization' }
SpClosedWindowListPresenter >> initializeRejectedWindows [
	"at the moment we reject only those windows by default"
	
	rejectedWindows := OrderedCollection new.
	rejectedWindows add: StDebugger.
	rejectedWindows add: StInspectorPresenter.
	rejectedWindows add: self class
]

{ #category : 'testing' }
SpClosedWindowListPresenter >> isWindowRejected: aWindow [

	^ (aWindow model notNil and: [
		   (rejectedWindows includes: aWindow model class) or: [
			   (aWindow model respondsTo: #presenter) and: [
				   aWindow model presenter notNil and: [
					   rejectedWindows includes: aWindow model presenter class ] ] ] ])
		  ifTrue: [ true ]
		  ifFalse: [ false ]
]

{ #category : 'accessing' }
SpClosedWindowListPresenter >> items [

	^ list model items
]

{ #category : 'accessing' }
SpClosedWindowListPresenter >> list [

	^ list 
]

{ #category : 'adding' }
SpClosedWindowListPresenter >> refresh [

	self list refresh.
	self resetSelection
]

{ #category : 'accessing' }
SpClosedWindowListPresenter >> removeButton [
	^ removeButton
]

{ #category : 'api' }
SpClosedWindowListPresenter >> removeItem: anObject [

	self items remove: anObject.
	"self resetSelection "
]

{ #category : 'api' }
SpClosedWindowListPresenter >> removeItemBlock: aBlock [
	removeItemBlock := aBlock.
]

{ #category : 'removing' }
SpClosedWindowListPresenter >> removeRejectedWindow: aWindowClass [

	rejectedWindows remove: aWindowClass 
]

{ #category : 'initialization' }
SpClosedWindowListPresenter >> resetRejectedWindows [

	rejectedWindows := OrderedCollection new
]

{ #category : 'api' }
SpClosedWindowListPresenter >> resetSelection [
	list selection basicSelectIndex: 1.


]

{ #category : 'api' }
SpClosedWindowListPresenter >> selectedItem [
	^ list selection selectedItem
]

{ #category : 'events subscription' }
SpClosedWindowListPresenter >> subscribeToWindowClosedAnnoucements [

	^ self class subscribeToWindowClosedAnnoucements
]

{ #category : 'accessing' }
SpClosedWindowListPresenter >> unhideButton [
	^ unhideButton 
]

{ #category : 'api' }
SpClosedWindowListPresenter >> unhideItemBlock: aBlock [
	unhideItemBlock := aBlock.
]

{ #category : 'events subscription' }
SpClosedWindowListPresenter >> unsubscribeToWindowClosedAnnoucements [

	^ self class unsubscribeToWindowClosedAnnoucements
]

{ #category : 'accessing' }
SpClosedWindowListPresenter >> windowTitle [
	^ 'Window Uncloser'
]
