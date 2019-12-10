"
I am a generic header bar for tool component panels. 
I am used to add title, a toolbar and shortcut used to get to the panel.
"
Class {
	#name : #StHeaderBar,
	#superclass : #SpPresenter,
	#instVars : [
		'titleLabel',
		'toolbar',
		'closeButton',
		'shortcutLabel'
	],
	#category : #'NewTools-Core'
}

{ #category : #specs }
StHeaderBar class >> defaultSpec [

	^ SpBoxLayout newHorizontal
		beNotHomogeneous;
		borderWidth: 3;
		spacing: 3;
		"add: #closeButton expand: false;"
		add: #titleLabel expand: false;
		add: #shortcutLabel expand: false;
		addLast: #toolbar expand: false;
		yourself
]

{ #category : #initialization }
StHeaderBar >> initializePresenters [

	closeButton := self newButton
		addStyle: 'button.mini';
		icon: (self application iconNamed: #windowClose);
		action: [ ];
		hide;
		yourself.
	titleLabel := self newLabel addStyle: 'label.header'; yourself.
	shortcutLabel := self newLabel
		addStyle: 'label.shortcut';
		yourself.
	toolbar := self newToolBar.
	toolbar beIcons
]

{ #category : #accessing }
StHeaderBar >> label: aString [

	titleLabel label: aString
]

{ #category : #accessing }
StHeaderBar >> shortcut: aShortcut [ 

	self shortcutLabel: (KMShortcutPrinter toString: aShortcut)
]

{ #category : #accessing }
StHeaderBar >> shortcutLabel: aString [ 

	shortcutLabel label: aString
]

{ #category : #accessing }
StHeaderBar >> toolbarActions: aCommandGroup [

	toolbar removeAllItems.
	SpToolBarPresenterBuilder new 
		toolbarPresenter: toolbar;
		visit: aCommandGroup
]
