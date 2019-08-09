Class {
	#name : #CreateAnonymousDebugCommandPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'nameField',
		'scriptField',
		'cancelButton',
		'createButton',
		'cancelCreateActionBar',
		'iconField'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
CreateAnonymousDebugCommandPresenter class >> defaultSpec [
	<spec: #default>

	| rowHeight |
	rowHeight := self inputTextHeight.

	^ SpBoxLayout newVertical
			add: 'Command name:' withConstraints: [:cstr | cstr height: rowHeight];
			add: #nameField withConstraints: [:cstr | cstr height: rowHeight];
			add: 'Icon:' withConstraints: [:cstr | cstr height: rowHeight];
			add: #iconField withConstraints: [:cstr | cstr height: rowHeight];
			add: 'Command script:' withConstraints: [:cstr | cstr height: rowHeight];
			add: #scriptField withConstraints: [:cstr | cstr expand: true. cstr fill: true];
			add: (SpBoxLayout newHorizontal
				addLast: #cancelCreateActionBar withConstraints: [ :cstr |
					cstr expand: false.
					cstr fill: false.
					cstr height: rowHeight.
					 ];
				yourself
			) withConstraints: [:cstr | cstr expand: false. cstr fill: false. cstr height: rowHeight];
			yourself
]

{ #category : #'as yet unclassified' }
CreateAnonymousDebugCommandPresenter >> createCommand [
	| name icon script |
	name := self findNonDuplicateNameOf: nameField text.
	icon := iconField text.
	script := scriptField text.
	DebugCommand
		newAnonymousActionLabeled: name
		icon: icon asSymbol
		executeScript: script
]

{ #category : #'as yet unclassified' }
CreateAnonymousDebugCommandPresenter >> findNonDuplicateNameOf: aString [
	| takenNames i |
	takenNames := DebugCommand AnonymousCommands collect: [ :cmd | cmd defaultCommandName ].
	(takenNames includes: aString) ifFalse: [ ^ aString ].
	i := 2.
	[ takenNames includes: aString, '#', i asString ] whileTrue: [ i := i + 1 ].
	^ aString, '#', i asString.
]

{ #category : #initialization }
CreateAnonymousDebugCommandPresenter >> initializeWidgets [
	nameField := self newTextInput.
	nameField
		autoAccept: true;
		text: 'MyCmd'.
	iconField := self newTextInput.
	iconField
		autoAccept: true;
		text: 'abstract'.
	scriptField := self newCode.
	scriptField
		autoAccept: true;
		text: 'dbg stepOver'.
	cancelButton := self newButton.
	createButton := self newButton.
	cancelCreateActionBar := self newActionBar
		add:
			(self newButton
				label: 'Cancel';
				icon: (self iconNamed: #smallCancel);
				help: 'Cancel.';
				action: [ self inform: 'Command creation cancelled'.
					self window close ];
				yourself);
		add:
			(self newButton
				label: 'Create';
				icon: (self iconNamed: #smallOk);
				help: 'Create.';
				action: [ self createCommand.
					self inform: 'Command created'.
					self window close ];
				yourself);
		yourself
]

{ #category : #TOREMOVE }
CreateAnonymousDebugCommandPresenter >> title [
	^ 'Create Sindarin Command'
]
