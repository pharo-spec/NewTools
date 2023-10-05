"
I am a presenter that provides a table to activate or unactivate debugger extensions
"
Class {
	#name : 'StDebuggerExtensionSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'debuggerExtensionClasses',
		'extensionClassesTable',
		'toolbar'
	],
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'accessing' }
StDebuggerExtensionSettingsPresenter class >> debuggerClass [

	^ StDebugger
]

{ #category : 'accessing' }
StDebuggerExtensionSettingsPresenter >> debuggerClass [

	^ self class debuggerClass
]

{ #category : 'layout' }
StDebuggerExtensionSettingsPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  borderWidth: 15;
		  spacing: 5;
		  add: (self newLabel label: 'Debugger extension settings')
		  expand: false;
		  add: #extensionClassesTable;
		  add: #toolbar expand: false;
		  yourself
]

{ #category : 'initialization' }
StDebuggerExtensionSettingsPresenter >> initialize [

	debuggerExtensionClasses := self debuggerClass extensionToolsClasses
		                            asOrderedCollection.
	super initialize
]

{ #category : 'initialization' }
StDebuggerExtensionSettingsPresenter >> initializePresenters [

	| activateAllButton unactivateAllButton |
	extensionClassesTable := self newTable
		                         beResizable;
		                         addColumn: (SpStringTableColumn
				                          title: 'Extension class'
				                          evaluated: [ :class |
					                          class basicNew
						                          debuggerExtensionToolName ]) yourself;
		                         addColumn: ((SpCheckBoxTableColumn
				                           title: 'Activated'
				                           evaluated: [ :class |
					                           class showInDebugger ])
				                          width: 60;
				                          onActivation: [ :class |
					                          class showInDebugger: true ];
				                          onDeactivation: [ :class |
					                          class showInDebugger: false ]);
		                         items: debuggerExtensionClasses;
		                         yourself.

	activateAllButton := self newToolbarButton
		                     action: [ self showAllInDebugger: true ];
		                     label: 'Activate all'.
	unactivateAllButton := self newToolbarButton
		                       action: [ self showAllInDebugger: false ];
		                       label: 'Unactivate all'.
	toolbar := self newToolbar
		           addItem: activateAllButton;
		           addItem: unactivateAllButton;
		           yourself
]

{ #category : 'actions' }
StDebuggerExtensionSettingsPresenter >> showAllInDebugger: aBoolean [

	debuggerExtensionClasses do: [ :class |
		class showInDebugger: aBoolean ].
	extensionClassesTable updateItemsKeepingSelection:
		debuggerExtensionClasses
]
