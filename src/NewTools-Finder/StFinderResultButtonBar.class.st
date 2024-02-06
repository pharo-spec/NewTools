"
I am a widget for the ̀Finder̀ tool. I represent contain the buttons used for
interacting with the results of a search.
"
Class {
	#name : 'StFinderResultButtonBar',
	#superclass : 'SpPresenter',
	#instVars : [
		'browseButton',
		'sendersButton',
		'versionsButton',
		'inheritanceButton',
		'hierarchyButton',
		'implementersButton'
	],
	#category : 'NewTools-Finder-Widgets',
	#package : 'NewTools-Finder',
	#tag : 'Widgets'
}

{ #category : 'api' }
StFinderResultButtonBar >> browseAction: aBlock [

	self browseButton action: aBlock
]

{ #category : 'accessing' }
StFinderResultButtonBar >> browseButton [

	^ browseButton
]

{ #category : 'layout' }
StFinderResultButtonBar >> defaultLayout [

	^ 	SpBoxLayout newHorizontal
		spacing: 2;
		add: browseButton expand: false;
		add: sendersButton expand: false;
		add: implementersButton expand: false;
		add: versionsButton expand: false;
		add: inheritanceButton expand: false;
		add: hierarchyButton expand: false;
		yourself
]

{ #category : 'enabling' }
StFinderResultButtonBar >> disableAll [

	browseButton disable.
	sendersButton disable.
	implementersButton disable.
	versionsButton disable.
	inheritanceButton disable.
	hierarchyButton disable
]

{ #category : 'enabling' }
StFinderResultButtonBar >> enableButtonsFor: aFinderResult [
	"Enables or disables result buttons depending on the defined
	 actions for aFinderResult."

	browseButton enabled: aFinderResult hasBrowseAction.
	sendersButton enabled: aFinderResult hasSendersAction.
	implementersButton enabled: aFinderResult hasImplementersAction.
	versionsButton enabled: aFinderResult hasVersionsAction.
	inheritanceButton enabled: aFinderResult hasInheritanceAction.
	hierarchyButton enabled: aFinderResult hasHierarchyAction
]

{ #category : 'api' }
StFinderResultButtonBar >> hierarchyAction: aBlock [

	self hierarchyButton action: aBlock
]

{ #category : 'accessing' }
StFinderResultButtonBar >> hierarchyButton [

	^ hierarchyButton
]

{ #category : 'api' }
StFinderResultButtonBar >> implementersAction: aBlock [

	self implementersButton action: aBlock
]

{ #category : 'accessing' }
StFinderResultButtonBar >> implementersButton [

	^ implementersButton
]

{ #category : 'api' }
StFinderResultButtonBar >> inheritanceAction: aBlock [

	self inheritanceButton action: aBlock
]

{ #category : 'accessing' }
StFinderResultButtonBar >> inheritanceButton [

	^ inheritanceButton
]

{ #category : 'initialization' }
StFinderResultButtonBar >> initializePresenters [

	browseButton := self newButton label: 'Browse'.
	sendersButton := self newButton label: 'Senders'.
	implementersButton := self newButton label: 'Implementors'.
	versionsButton := self newButton label: 'Versions'.
	inheritanceButton := self newButton label: 'Inheritance'.
	hierarchyButton := self newButton label: 'Hierarchy'.

	self disableAll
]

{ #category : 'api' }
StFinderResultButtonBar >> sendersAction: aBlock [

	self sendersButton action: aBlock
]

{ #category : 'accessing' }
StFinderResultButtonBar >> sendersButton [

	^ sendersButton
]

{ #category : 'api' }
StFinderResultButtonBar >> versionsAction: aBlock [

	self versionsButton action: aBlock
]

{ #category : 'accessing' }
StFinderResultButtonBar >> versionsButton [

	^ versionsButton
]
