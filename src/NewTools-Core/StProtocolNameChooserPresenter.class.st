"
I am a little interface to let the user choose the name of a protocol.

This interface will suggest the name of the protocol as the user types the beginning of the name.

I can be configured with a concerned class to refine the UI such as proposing instance or class side protocols in the suggestion list.

See my class side for an example of usage and some helpers.

Idea of improvements for the future:
- Suggest protocols from super classes first?
- Add tests
"
Class {
	#name : 'StProtocolNameChooserPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'suggestionList',
		'protocolNameField',
		'concernedClass',
		'newProtocolButton'
	],
	#category : 'NewTools-Core-Calypso',
	#package : 'NewTools-Core',
	#tag : 'Calypso'
}

{ #category : 'examples' }
StProtocolNameChooserPresenter class >> exampleConfiguringPresenter [

	<example>
	self requestProtocolNameConfiguring: [ :presenter :dialog |
		presenter
			concernedClass: self class; "Giving the concerned class can allow some customizations such as knowing if we should suggest instance or class side protocols"
			protocolName: 'ac'.
		dialog title: 'Updated title' ]
]

{ #category : 'instance creation' }
StProtocolNameChooserPresenter class >> open [

	<script>
	self new open
]

{ #category : 'instance creation' }
StProtocolNameChooserPresenter class >> requestProtocolName [
	"See comment of StProtocolNameChooser class>>#requestProtocolNameConfiguring:"

	<script>
	^ self requestProtocolNameConfiguring: [ :presenter :dialog |  ]
]

{ #category : 'instance creation' }
StProtocolNameChooserPresenter class >> requestProtocolNameConfiguring: aBlock [
	"I request a protocol name through a dialog and signal a CmdCommandAborted in case the provided protocol is empty or an extension name.
	I allow the user to configure the presenter or the dialog via a configuration block."

	<script>
	| protocolName presenter dialog |
	dialog := (presenter := self new) asBlockedDialogWindow.

	aBlock cull: presenter cull: dialog.

	presenter selectProtocolName.

	dialog open.
	
	dialog cancelled ifTrue: [ CmCommandAborted signal ].

	protocolName := presenter selectedItem ifNil: [ CmCommandAborted signal ].
	

	(protocolName beginsWith: '*') ifTrue: [
		UIManager default inform: 'Star is forbidden for protocol name since this is used for method extensions.'.
		^ CmCommandAborted signal ].
	^ protocolName
]

{ #category : 'accessing' }
StProtocolNameChooserPresenter >> concernedClass [
	"Giving the concerned class can allow some customizations such as knowing if we should suggest instance or class side protocols"

	^ concernedClass
]

{ #category : 'accessing' }
StProtocolNameChooserPresenter >> concernedClass: anObject [

	concernedClass := anObject
]

{ #category : 'initialization' }
StProtocolNameChooserPresenter >> connectPresenters [

	super connectPresenters.

	protocolNameField whenTextChangedDo: [ self updatePresenter ].
]

{ #category : 'layout' }
StProtocolNameChooserPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: suggestionList;
		  add: (SpBoxLayout newLeftToRight
				   add: protocolNameField expand: true;
				   add: newProtocolButton expand: false;
				   yourself)
		  withConstraints: [ :constraints | constraints height: self class toolbarHeight ];
		  yourself
]

{ #category : 'initialization' }
StProtocolNameChooserPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	super initializeDialogWindow: aDialogWindowPresenter.
	protocolNameField whenSubmitDo: [ :protocolName | aDialogWindowPresenter triggerOkAction ].

	newProtocolButton action: [ "If we click on the + we should add the content of the input field in the list, select it and validate"
		suggestionList
			items: { protocolNameField text };
			selectFirst.

		aDialogWindowPresenter triggerOkAction ]
]

{ #category : 'initialization' }
StProtocolNameChooserPresenter >> initializePresenters [

	super initializePresenters.

	suggestionList := self newList.

	protocolNameField := self newTextInput.
	protocolNameField placeholder: 'Protocol name (e.g. accessing)'.

	newProtocolButton := self newButton.
	newProtocolButton
		icon: (self iconNamed: #add);
		help: 'Create a new protocol with the content of the input field if this protocol is not in the list'.

	self initializeProtocolNameField
]

{ #category : 'initialization' }
StProtocolNameChooserPresenter >> initializeProtocolNameField [

	protocolNameField eventHandler whenKeyDownDo: [ :anEvent | "If we press arrow up, we should get up in the list. If we press arrow down, we should get down in the list.""31 = Arrow down"
		anEvent keyValue = 31 ifTrue: [
			suggestionList selectIndex: (suggestionList selection selectedIndex + 1 min: suggestionList items size) scrollToSelection: true ].

		"30 = Arrow up"
		anEvent keyValue = 30 ifTrue: [ suggestionList selectIndex: (suggestionList selection selectedIndex - 1 max: 1) scrollToSelection: true ] ]
]

{ #category : 'initialization' }
StProtocolNameChooserPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'New protocol name'.
	aWindowPresenter whenOpenedDo: [ protocolNameField takeKeyboardFocus ]
]

{ #category : 'accessing' }
StProtocolNameChooserPresenter >> newProtocolButton [

	^ newProtocolButton
]

{ #category : 'accessing' }
StProtocolNameChooserPresenter >> protocolName [
	^ protocolNameField text asSymbol
]

{ #category : 'accessing' }
StProtocolNameChooserPresenter >> protocolName: aString [
	"I allow to set a default protocol name to the list."

	protocolNameField text: aString.
	self updatePresenter
]

{ #category : 'initialization' }
StProtocolNameChooserPresenter >> protocolsToSuggest [

	| suggestedProtocols |
	suggestedProtocols := concernedClass environment allClasses flatCollect: [ :class |
		                      (concernedClass isNil or: [ concernedClass isInstanceSide ])
			                      ifTrue: [ class protocols ]
			                      ifFalse: [ class class protocols ] ].
	suggestedProtocols := suggestedProtocols reject: [ :protocol | protocol isExtensionProtocol ].
	suggestedProtocols := suggestedProtocols collect: [ :protocol | protocol name ] as: Bag.
	suggestedProtocols := suggestedProtocols sortedCounts collect: [ :association | association value ].
	suggestedProtocols := suggestedProtocols select: [ :protocolName | protocolName includesSubstring: self protocolName ].
	^ suggestedProtocols
]

{ #category : 'accessing' }
StProtocolNameChooserPresenter >> selectProtocolName [

	protocolNameField selectAll
]

{ #category : 'accessing' }
StProtocolNameChooserPresenter >> selectedItem [

	^ suggestionList selectedItem
]

{ #category : 'initialization' }
StProtocolNameChooserPresenter >> updatePresenter [

	newProtocolButton enabled: self protocolName isNotEmpty.

	suggestionList
		items: self protocolsToSuggest;
		selectFirst
]
