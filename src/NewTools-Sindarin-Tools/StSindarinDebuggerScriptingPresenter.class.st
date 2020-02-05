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
	toolbar := self newToolBar
]
