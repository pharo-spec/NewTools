Class {
	#name : 'StSindarinDebuggerCommandPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'descriptionInput',
		'cancelButton',
		'createButton',
		'package',
		'iconList',
		'iconNameSelected',
		'commandName',
		'code',
		'projectName'
	],
	#category : 'NewTools-Sindarin-Tools-Presenters',
	#package : 'NewTools-Sindarin-Tools',
	#tag : 'Presenters'
}

{ #category : 'accessing' }
StSindarinDebuggerCommandPresenter >> code: aCode [

	code := aCode
]

{ #category : 'accessing' }
StSindarinDebuggerCommandPresenter >> commandName: aName [

	commandName := aName asCamelCase
]

{ #category : 'initialization' }
StSindarinDebuggerCommandPresenter >> connectPresenters [

	iconList transmitTo: self
]

{ #category : 'layout' }
StSindarinDebuggerCommandPresenter >> defaultLayout [

	| buttonRow |
	buttonRow := SpBoxLayout newLeftToRight
		             spacing: 6;
		             add: createButton;
		             add: cancelButton;
		             yourself.

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: descriptionInput expand: false;
		  add: iconList;
		  add: buttonRow expand: false;
		  yourself
]

{ #category : 'actions' }
StSindarinDebuggerCommandPresenter >> deleteCommand [

	| name className commandsLeft |
	name := commandName ifNil: [ 'NoName' ].
	className := 'Sindarin{1}{2}Command' format: {
			             projectName asCamelCase.
			             name asCamelCase }.

	(Smalltalk globals includesKey: className asSymbol) ifTrue: [
		(Smalltalk globals at: className asSymbol) removeFromSystem ].

	commandsLeft := SindarinCommand subclasses select: [ :sub |
		                sub packageName = package ].
	commandsLeft isEmpty ifTrue: [ self deleteMenu ]
]

{ #category : 'actions' }
StSindarinDebuggerCommandPresenter >> deleteMenu [

	| buildGroupMethodName |
	buildGroupMethodName := 'buildSindarin{1}ExtentionCommandsGroupWith:forRoot:'
		                        format: { projectName asCamelCase }.

	(StDebugger class includesSelector: buildGroupMethodName asSymbol)
		ifTrue: [
		StDebugger class removeSelector: buildGroupMethodName asSymbol ]
]

{ #category : 'actions' }
StSindarinDebuggerCommandPresenter >> generateCommand [

	| name className description class |
	name := commandName ifNil: [ 'NoName' ].
	className := 'Sindarin{1}{2}Command' format: {
			             projectName asCamelCase.
			             name asCamelCase }.
	description := descriptionInput text ifNil: [ '' ].

	class := (SindarinCommand << className)
		         package: package;
					tag: 'Scripts';
		         build;
		         install.

	class
		compile: ('execute
	|sindarin|
	sindarin := self context sindarinDebugger.
	self context debuggerClientModel preventUpdatesDuring: [
		{1}
	]' format: { code })
		classified: 'executing'.

	class class
		compile: ('defaultIconName
	^#{1}' format: { iconNameSelected })
		classified: 'initialization'.

	class class
		compile: ('defaultDescription
	^ ''{1}''' format: { description })
		classified: 'initialization'.

	class class
		compile: ('defaultName
	^ ''{1}''' format: { name })
		classified: 'initialization'.

	class comment:
		('This command was generated dynamically on {1} at {2}.
Project: {3}
Name: {4}
Description: {5}' format: {
				 Date today yyyymmdd.
				 Time now print24.
				 projectName.
				 name.
				 description }).

	self generateMenu
]

{ #category : 'actions' }
StSindarinDebuggerCommandPresenter >> generateMenu [

	StDebugger class
		compile:
			('buildSindarin{2}ExtentionCommandsGroupWith: stDebuggerInstance forRoot: rootCommandGroup
	<extensionCommands>
	| commands toolbarCommandGroup |
	commands := (SindarinCommand subclasses select: [ :sub | sub packageName = ''{3}'']) collect: [ :each | each forSpecContext: stDebuggerInstance ].
	
	toolbarCommandGroup := CmCommandGroup forSpec
		beToolbarPopoverButton;
		name: ''{1}'';
		icon: (stDebuggerInstance application iconNamed: #changeUpdate);
		yourself.
	
	(self debuggerToolbarCommandGroupFor: rootCommandGroup) register: toolbarCommandGroup.
	
	commands do: [ :command | toolbarCommandGroup register: command ].'
				 format: {
						 projectName.
						 projectName asCamelCase.
						 package })
		classified: '*' , package
]

{ #category : 'initialization' }
StSindarinDebuggerCommandPresenter >> initializeIconList [

	| icons |
	icons := ThemeIcons loadDefault.
	iconList
		items: icons allIconNames;
		display: [ :elm | ThemeIcons iconNamed: elm ]
]

{ #category : 'initialization' }
StSindarinDebuggerCommandPresenter >> initializePresenters [

	descriptionInput := self newTextInput.
	descriptionInput placeholder: 'Command description'.

	iconList := self newList.
	self initializeIconList.

	createButton := self newButton.
	createButton label: 'Create'.

	cancelButton := self newButton.
	cancelButton label: 'Cancel'
]

{ #category : 'accessing' }
StSindarinDebuggerCommandPresenter >> package: aPackageName [

	package := aPackageName
]

{ #category : 'accessing' }
StSindarinDebuggerCommandPresenter >> projectName: aName [

	projectName := aName
]

{ #category : 'transmission' }
StSindarinDebuggerCommandPresenter >> setModel: aIconName [

	iconNameSelected := aIconName
]

{ #category : 'enumerating' }
StSindarinDebuggerCommandPresenter >> whenCancelDo: aBlock [

	cancelButton action: aBlock
]

{ #category : 'enumerating' }
StSindarinDebuggerCommandPresenter >> whenCreateDo: aBlock [

	createButton action: aBlock
]
