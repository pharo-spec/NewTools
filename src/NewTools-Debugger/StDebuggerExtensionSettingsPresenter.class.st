"
I am a presenter that provides a table to activate or unactivate debugger extensions
"
Class {
	#name : 'StDebuggerExtensionSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'debuggerExtensionClasses',
		'extensionClassesTable',
		'activateAllCheckbox'
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
		  add: #activateAllCheckbox expand: false;
		  add: #extensionClassesTable;
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

	activateAllCheckbox := self newCheckBox
		                       label: '(Un)Activate all';
		                       state:
			                       (debuggerExtensionClasses allSatisfy: [
					                        :class | class showInDebugger ]);
		                       whenActivatedDo: [
			                       self showAllInDebugger: true ];
		                       whenDeactivatedDo: [
			                       self showAllInDebugger: false ];
		                       yourself
]

{ #category : 'actions' }
StDebuggerExtensionSettingsPresenter >> showAllInDebugger: aBoolean [

	debuggerExtensionClasses do: [ :class |
		class showInDebugger: aBoolean ].
	extensionClassesTable updateItemsKeepingSelection:
		debuggerExtensionClasses
]
