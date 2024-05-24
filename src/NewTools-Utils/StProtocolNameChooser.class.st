"
I am a little interface to let the user choose the name of a protocol.

This interface will suggest the name of the protocol as the user types the beginning of the name.
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

{ #category : 'helpers' }
StProtocolNameChooser class >> forClass: aClass [

	^ self new
		  concernedClass: aClass;
		  yourself
]

{ #category : 'instance creation' }
StProtocolNameChooser class >> open [

	<script>
	self new open
]

{ #category : 'accessing' }
StProtocolNameChooser >> concernedClass [

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

	protocolNameField := self newTextInput
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
