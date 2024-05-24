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
	#name : 'StProtocolNameChooser',
	#superclass : 'StPresenter',
	#instVars : [
		'suggestionList',
		'protocolNameField',
		'concernedClass'
	],
	#category : 'NewTools-Utils-ProtocolChooser',
	#package : 'NewTools-Utils',
	#tag : 'ProtocolChooser'
}

{ #category : 'examples' }
StProtocolNameChooser class >> exampleConfiguringPresenter [

	<example>
	self requestProtocolNameConfiguring: [ :presenter :dialog |
		presenter
			concernedClass: self class; "Giving the concerned class can allow some customizations such as knowing if we should suggest instance or class side protocols"
			protocolName: 'ac'.
		dialog title: 'Updated title' ]
]

{ #category : 'instance creation' }
StProtocolNameChooser class >> open [

	<script>
	self new open
]

{ #category : 'instance creation' }
StProtocolNameChooser class >> requestProtocolName [
	"See comment of StProtocolNameChooser class>>#requestProtocolNameConfiguring:"

	<script>
	^ self requestProtocolNameConfiguring: [ :presenter :dialog |  ]
]

{ #category : 'instance creation' }
StProtocolNameChooser class >> requestProtocolNameConfiguring: aBlock [
	"I request a protocol name through a dialog and signal a CmdCommandAborted in case the provided protocol is empty or an extension name.
	I allow the user to configure the presenter or the dialog via a configuration block."

	<script>
	| protocolName presenter dialog |
	dialog := (presenter := self new) asBlockedDialogWindow.

	aBlock cull: presenter cull: dialog.

	dialog open.

	protocolName := presenter protocolName.

	protocolName isEmptyOrNil ifTrue: [ CmdCommandAborted signal ].
	(protocolName beginsWith: '*') ifTrue: [
		self inform: 'Star is forbidden for protocol name since this is used for method extensions.'.
		^ CmdCommandAborted signal ].
	^ protocolName
]

{ #category : 'accessing' }
StProtocolNameChooser >> concernedClass [
	"Giving the concerned class can allow some customizations such as knowing if we should suggest instance or class side protocols"

	^ concernedClass
]

{ #category : 'accessing' }
StProtocolNameChooser >> concernedClass: anObject [

	concernedClass := anObject
]

{ #category : 'initialization' }
StProtocolNameChooser >> connectPresenters [

	super connectPresenters.

	protocolNameField whenTextChangedDo: [ self updatePresenter ]
]

{ #category : 'layout' }
StProtocolNameChooser >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: suggestionList;
		  add: protocolNameField expand: false;
		  yourself
]

{ #category : 'initialization' }
StProtocolNameChooser >> initializeDialogWindow: aDialogWindowPresenter [

	super initializeDialogWindow: aDialogWindowPresenter.
	protocolNameField whenSubmitDo: [ :protocolName | aDialogWindowPresenter triggerOkAction ].
	suggestionList whenSelectedDo: [ :protocolName | self protocolName: protocolName ]
]

{ #category : 'initialization' }
StProtocolNameChooser >> initializePresenters [

	super initializePresenters.

	suggestionList := self newList.

	protocolNameField := self newTextInput.
	protocolNameField placeholder: 'Protocol name (e.g. accessing)'
]

{ #category : 'initialization' }
StProtocolNameChooser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'New protocol name'.

	aWindowPresenter whenOpenedDo: [ protocolNameField takeKeyboardFocus ]
]

{ #category : 'accessing - defaults' }
StProtocolNameChooser >> protocolName [
	^ protocolNameField text asSymbol
]

{ #category : 'accessing' }
StProtocolNameChooser >> protocolName: aString [
	"I allow to set a default protocol name to the list."

	protocolNameField text: aString.
	self updatePresenter
]

{ #category : 'initialization' }
StProtocolNameChooser >> updatePresenter [

	| existingProtocols |
	existingProtocols := concernedClass environment allClasses flatCollect: [ :class |
		                     (concernedClass isNil or: [ concernedClass isInstanceSide ])
			                     ifTrue: [ class protocols ]
			                     ifFalse: [ class class protocols ] ].
	existingProtocols := existingProtocols reject: [ :protocol | protocol isExtensionProtocol ].
	existingProtocols := existingProtocols collect: [ :protocol | protocol name ] as: Bag.
	existingProtocols := existingProtocols sortedCounts collect: [ :association | association value ].

	suggestionList items: (existingProtocols select: [ :protocolName | protocolName includesSubstring: self protocolName ])
]
