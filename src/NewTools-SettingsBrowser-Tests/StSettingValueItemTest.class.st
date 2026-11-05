"
I test that the settings items show the value of their setting without writing it back: the setter of a setting may have side effects (e.g. the font size resets all the fonts).
Only the edits of the user write the setting.

I am the target of the tested settings, and I record the names of the settings written in `writes`.
"
Class {
	#name : 'StSettingValueItemTest',
	#superclass : 'TestCase',
	#instVars : [
		'enabled',
		'count',
		'label',
		'choice',
		'writes'
	],
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'accessing' }
StSettingValueItemTest >> choice [

	^ choice
]

{ #category : 'accessing' }
StSettingValueItemTest >> choice: aSymbol [

	writes add: #choice.
	choice := aSymbol
]

{ #category : 'helpers' }
StSettingValueItemTest >> choiceSetting [

	^ PickOneSetting new
		  name: #choice;
		  domainValues: {
				  ('First' -> #first).
				  ('Second' -> #second) };
		  yourself
]

{ #category : 'accessing' }
StSettingValueItemTest >> count [

	^ count
]

{ #category : 'accessing' }
StSettingValueItemTest >> count: aNumber [

	writes add: #count.
	count := aNumber
]

{ #category : 'accessing' }
StSettingValueItemTest >> enabled [

	^ enabled
]

{ #category : 'accessing' }
StSettingValueItemTest >> enabled: aBoolean [

	writes add: #enabled.
	enabled := aBoolean
]

{ #category : 'helpers' }
StSettingValueItemTest >> itemFor: aSetting [

	aSetting parentGroup: (SettingsGroup new
			 name: #group;
			 target: self;
			 yourself).
	^ aSetting asSettingPresenterWithOwner: StSettingDetailPresenter new
]

{ #category : 'accessing' }
StSettingValueItemTest >> label [

	^ label
]

{ #category : 'accessing' }
StSettingValueItemTest >> label: aString [

	writes add: #label.
	label := aString
]

{ #category : 'running' }
StSettingValueItemTest >> setUp [

	super setUp.
	enabled := true.
	count := 3.
	label := 'initial'.
	choice := #second.
	writes := OrderedCollection new
]

{ #category : 'helpers' }
StSettingValueItemTest >> settingNamed: aSymbol [

	^ Setting new
		  name: aSymbol;
		  yourself
]

{ #category : 'tests' }
StSettingValueItemTest >> testEditingABooleanWritesIt [

	| item |
	item := self itemFor: (self settingNamed: #enabled).

	item setterPresenter state: false.

	self deny: enabled.
	self assert: writes asArray equals: #( #enabled )
]

{ #category : 'tests' }
StSettingValueItemTest >> testEditingAChoiceWritesIt [

	| item |
	item := self itemFor: self choiceSetting.

	item setterPresenter selectIndex: 1.

	self assert: choice equals: #first.
	self assert: writes asArray equals: #( #choice )
]

{ #category : 'tests' }
StSettingValueItemTest >> testEditingANumberWritesIt [

	| item |
	item := self itemFor: (self settingNamed: #count).

	item setterPresenter number: 4.

	self assert: count equals: 4.
	self assert: writes asArray equals: #( #count )
]

{ #category : 'tests' }
StSettingValueItemTest >> testEditingATextWritesIt [

	| item |
	item := self itemFor: (self settingNamed: #label).

	item setterPresenter text: 'edited'.

	self assert: label equals: 'edited'.
	self assert: writes asArray equals: #( #label )
]

{ #category : 'tests' }
StSettingValueItemTest >> testShowingABooleanDoesNotWriteIt [

	| item |
	item := self itemFor: (self settingNamed: #enabled).

	self assert: item setterPresenter state.
	self assert: writes isEmpty
]

{ #category : 'tests' }
StSettingValueItemTest >> testShowingAChoiceDoesNotWriteIt [

	| item |
	item := self itemFor: self choiceSetting.

	self assert: item setterPresenter selectedItem value equals: #second.
	self assert: writes isEmpty
]

{ #category : 'tests' }
StSettingValueItemTest >> testShowingANumberDoesNotWriteIt [

	| item |
	item := self itemFor: (self settingNamed: #count).

	self assert: item setterPresenter number equals: 3.
	self assert: writes isEmpty
]

{ #category : 'tests' }
StSettingValueItemTest >> testShowingATextDoesNotWriteIt [

	| item |
	item := self itemFor: (self settingNamed: #label).

	self assert: item setterPresenter text equals: 'initial'.
	self assert: writes isEmpty
]
