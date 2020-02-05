"
I am a StDebugger extension for scripting the developer's debugging session.
I provides ways to:
- write a live script directly in the debugger (and affecting the debug session)
- save/load scripts
- create debugging commands from scripts
"
Class {
	#name : #StSindarinDebuggerScriptingPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'code',
		'resultInspection',
		'toolbar'
	],
	#category : #'NewTools-Sindarin-Tools'
}

{ #category : #specs }
StSindarinDebuggerScriptingPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolbar expand: false fill: false padding: 0;
		add: #code;
		add: 'Result (right click to see more...)' expand: false fill: false padding: 5;
		add: #resultInspection;
		yourself
]

{ #category : #specs }
StSindarinDebuggerScriptingPresenter class >> extendedDebuggingToolTitle [
	<debuggerExtensionPresentationOrder: -1>
	^ 'Sindarin'
]

{ #category : #actions }
StSindarinDebuggerScriptingPresenter >> executeScriptingBoxContent: aString [
	self flag: 'todo'
	"self executeScriptingBoxContent: self scriptingBox getText asString"
	"specDebugger stack stopAutoUpdate.
	OpalCompiler new
		bindings: { #dbg -> specDebuggerWrapper }	asDictionary;
		evaluate: aString.
	specDebugger stack updateContentFromSession.
	specDebugger stack startAutoUpdate."
	
]

{ #category : #initialization }
StSindarinDebuggerScriptingPresenter >> initializePresenters [
	code := self newCode.
	code syntaxHighlight: true.
	code autoAccept: true.
	code acceptBlock: [ :txt |  ].
	"code contextMenu: [  ]."
	code text: 'self stepOver'.
	resultInspection := nil rawInspection.
	self initializeToolbar
]

{ #category : #initialization }
StSindarinDebuggerScriptingPresenter >> initializeToolbar [
	toolbar := self newToolBar.
	toolbar beIcons.
	SpToolBarPresenterBuilder new
		toolbarPresenter: toolbar;
		visit: self toolbarActions
]

{ #category : #actions }
StSindarinDebuggerScriptingPresenter >> toolbarActions [
	| group |
	group := (CmCommandGroup named: 'Toolbar') asSpecGroup.
	
	group register: (SindarinRunScriptCommand forSpecContext: self).
	group register: (SindarinSaveScriptCommand forSpecContext: self).
	group register: (SindarinLoadScriptCommand forSpecContext: self).
	group register: (SindarinCreateCommandFromScriptCommand forSpecContext: self).
	group register: (SindarinRemoveCommandCommand forSpecContext: self).
	group register: (StInspectorHelpCommand forSpecContext: self).

	
	^ group
]
