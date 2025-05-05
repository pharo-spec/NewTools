"
I am a StDebugger extension for scripting the developer's debugging session.
I provides ways to:
- write a live script directly in the debugger (and affecting the debug session)
- save/load scripts
- create debugging commands from scripts

My owner must be a spec debugger
"
Class {
	#name : 'StSindarinDebuggerScriptingPresenter',
	#superclass : 'SpPresenter',
	#traits : 'TStDebuggerExtension',
	#classTraits : 'TStDebuggerExtension classTrait',
	#instVars : [
		'code',
		'resultInspection',
		'toolbar',
		'sindarinDebugger',
		'resultLabel',
		'hasUnsavedCodeChanges'
	],
	#category : 'NewTools-Sindarin-Tools-Presenters',
	#package : 'NewTools-Sindarin-Tools',
	#tag : 'Presenters'
}

{ #category : 'visiting' }
StSindarinDebuggerScriptingPresenter >> accept: aVisitor [

	^ aVisitor visitSindarin: self
]

{ #category : 'actions' }
StSindarinDebuggerScriptingPresenter >> createCommandFromScript [
	self flag: 'todo'
]

{ #category : 'accessing' }
StSindarinDebuggerScriptingPresenter >> debuggerActionModel [
	^self debugger debuggerActionModel
]

{ #category : 'debugger extension' }
StSindarinDebuggerScriptingPresenter >> debuggerExtensionToolName [

	^ 'Scripts'
]

{ #category : 'layout' }
StSindarinDebuggerScriptingPresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: #toolbar expand: false;
		add: #code;
		add: #resultLabel 
			expand: false 
			fill: false 
			padding: 5;
		add: #resultInspection;
		yourself
]

{ #category : 'actions' }
StSindarinDebuggerScriptingPresenter >> executeScript [

	| stream result model receiver evaluationContext |
	self debuggerActionModel preventUpdatesDuring: [ 
		stream := code text readStream.
		model := code interactionModel.
		receiver := model context receiver.
		evaluationContext := model context.
		result := receiver class compiler
			          source: stream;
			          context: evaluationContext;
			          receiver: receiver;
			          requestor: model;
			          failBlock: [ nil ];
			          evaluate.
		resultInspection model: result.
		resultInspection update ]
]

{ #category : 'accessing' }
StSindarinDebuggerScriptingPresenter >> hasUnsavedCodeChanges [

	^ hasUnsavedCodeChanges ifNil: [ hasUnsavedCodeChanges := false ]
]

{ #category : 'initialization' }
StSindarinDebuggerScriptingPresenter >> initializePresenters [

	resultLabel := self newLabel.
	code := self newCode.
	code syntaxHighlight: true.
	code text: 'sindarin stepOver'.
	code whenTextChangedDo: [
		hasUnsavedCodeChanges := true.
		self updateLabel ].
	resultInspection := nil inspectionRaw.
	resultInspection owner: self.
	self initializeToolbar.
	self updateLabel
]

{ #category : 'initialization' }
StSindarinDebuggerScriptingPresenter >> initializeToolbar [

	toolbar := self newToolbar
		addStyle: 'stToolbar';
		beIcons;
		fillWith: self toolbarActions
]

{ #category : 'actions' }
StSindarinDebuggerScriptingPresenter >> loadScript [
	self flag: 'todo'
]

{ #category : 'actions' }
StSindarinDebuggerScriptingPresenter >> removeScriptCommand [
	self flag: 'todo'
]

{ #category : 'actions' }
StSindarinDebuggerScriptingPresenter >> saveScript [
	self flag: 'todo'.
	hasUnsavedCodeChanges := false.
	self updateLabel 
]

{ #category : 'accessing' }
StSindarinDebuggerScriptingPresenter >> setModelBeforeInitialization: aStDebugger [
	"My original model is the debugger presenter that I extend"
	debugger := aStDebugger.
	sindarinDebugger := aStDebugger sindarinDebugger
]

{ #category : 'accessing' }
StSindarinDebuggerScriptingPresenter >> sindarin [
	^sindarinDebugger 
]

{ #category : 'building' }
StSindarinDebuggerScriptingPresenter >> toolbarActions [
	| group |
	group := (CmCommandGroup named: 'Toolbar') asSpecGroup.
	
	group register: (SindarinRunScriptCommand forSpecContext: self).
	group register: (SindarinSaveScriptCommand forSpecContext: self).
	group register: (SindarinLoadScriptCommand forSpecContext: self).
	group register: (SindarinCreateCommandFromScriptCommand forSpecContext: self).
	group register: (SindarinRemoveCommandCommand forSpecContext: self).

	
	^ group
]

{ #category : 'initialization' }
StSindarinDebuggerScriptingPresenter >> updateCode [

	| interactionModel |
	interactionModel := StSindarinContextInteractionModel on:
		                    self debuggerActionModel interruptedContext.
	interactionModel addBinding:
		(WorkspaceVariable key: #sindarin value: self sindarin).
	code interactionModel: interactionModel
]

{ #category : 'updating' }
StSindarinDebuggerScriptingPresenter >> updateLabel [

	self hasUnsavedCodeChanges ifTrue: [
		resultLabel label: '*unsaved script'.
		resultLabel addStyle: 'headerError'.
		^ self ].
	resultLabel label: 'Execute script to see results'.
	resultLabel addStyle: 'header'.
	resultLabel removeStyle: 'headerError'
]

{ #category : 'initialization' }
StSindarinDebuggerScriptingPresenter >> updatePresenter [

	self updateCode.
	super updatePresenter
]
