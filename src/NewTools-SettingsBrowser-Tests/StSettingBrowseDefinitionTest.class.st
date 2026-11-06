"
I test the ""Browse definition"" command of the setting rows of the Settings Browser (`StSettingPresenterItem` and its subclasses).

## Responsibility:

- I check that every kind of setting row declares a ""Browse definition"" action bound to Cmd+B.
- I check that browsing a definition opens the system browser on the method declaring the setting, with the setting name selected.
- I close the browsers opened by my tests.

## Collaborators: 

- `StPharoApplication`: the application of the rows under test, it answers the system browser for `toolNamed: #browser`.
- `ClyFullBrowserMorph`: the system browser opened by the tests.
- `SettingsBuilder`: builds the settings declared by my class side under the `<stSettingBrowseDefinitionTest>` pragma.
- `SettingsManager`: gives the real system settings browsed by the tests.
- `StSettingDetailPresenter`: the owner of the rows under test.

## Public API and Key Messages

- `rowFor:` answers the row presenter of one of my test settings.
- `browseDefinitionOf:` browses the definition of a row and remembers the browser to close it.

```
StSettingBrowseDefinitionTest suite run
```

## Internal Representation

- `application`: the application shared by the rows.
- `browsers`: the browsers opened by the test, closed in `tearDown`.
- Class side: `browsedBoolean`, `browsedText` hold the values of the test settings.

### Implementation Points

- `browseDefinitionSettingsOn:` declares one test setting per kind of row, used to check the actions of the rows.
- The tests opening a browser use real system settings (`#defaultDirectory`, and `#preferRoundCorner` which is declared in a helper method): the browser cannot highlight class side methods of test classes.
"
Class {
	#name : 'StSettingBrowseDefinitionTest',
	#superclass : 'TestCase',
	#instVars : [
		'application',
		'browsers'
	],
	#classInstVars : [
		'browsedBoolean',
		'browsedText'
	],
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'settings' }
StSettingBrowseDefinitionTest class >> browseDefinitionSettingsOn: aBuilder [
	"Declare one setting per kind of row checked by my tests"

	<stSettingBrowseDefinitionTest>
	(aBuilder group: #browseDefinitionTest)
		label: 'Browse definition test';
		with: [
				(aBuilder setting: #browsedBoolean)
					label: 'Browsed boolean';
					target: self.
				(aBuilder setting: #browsedText)
					label: 'Browsed text';
					target: self.
				(aBuilder setting: #browsedDirectory)
					label: 'Browsed directory';
					target: self ]
]

{ #category : 'accessing' }
StSettingBrowseDefinitionTest class >> browsedBoolean [

	^ browsedBoolean ifNil: [ true ]
]

{ #category : 'accessing' }
StSettingBrowseDefinitionTest class >> browsedBoolean: aBoolean [

	browsedBoolean := aBoolean
]

{ #category : 'accessing' }
StSettingBrowseDefinitionTest class >> browsedDirectory [

	^ FileSystem memory root
]

{ #category : 'accessing' }
StSettingBrowseDefinitionTest class >> browsedDirectory: aFileReference [

	
]

{ #category : 'accessing' }
StSettingBrowseDefinitionTest class >> browsedText [

	^ browsedText ifNil: [ 'text' ]
]

{ #category : 'accessing' }
StSettingBrowseDefinitionTest class >> browsedText: aString [

	browsedText := aString
]

{ #category : 'helpers' }
StSettingBrowseDefinitionTest >> browseDefinitionActionOf: aRow [
	"Answer the 'Browse definition' action of aRow, nil if it has none"

	aRow actions ifNil: [ ^ nil ].
	^ aRow actions allCommands detect: [ :each | each name = 'Browse definition' ] ifNone: [ nil ]
]

{ #category : 'helpers' }
StSettingBrowseDefinitionTest >> browseDefinitionOf: aRow [
	"Browse the definition of aRow and answer the opened browser, closed in tearDown"

	^ browsers add: aRow browseDefinition
]

{ #category : 'helpers' }
StSettingBrowseDefinitionTest >> browsedWindowsDuring: aBlock [
	"Answer the system browsers opened while evaluating aBlock; they are closed in tearDown"

	| before opened |
	before := ClyFullBrowserMorph allInstances asIdentitySet.
	aBlock value.
	opened := ClyFullBrowserMorph allInstances reject: [ :each | before includes: each ].
	browsers addAll: opened.
	^ opened
]

{ #category : 'helpers' }
StSettingBrowseDefinitionTest >> editedMethodIn: aBrowser [

	aBrowser withTool: ClyMethodCodeEditorToolMorph do: [ :editor | ^ editor editingMethod ].
	^ nil
]

{ #category : 'helpers' }
StSettingBrowseDefinitionTest >> rowFor: aSettingName [
	"Answer the row presenter of one of the settings declared by my class side"

	| setting |
	setting := (SettingsBuilder forPragmaNamed: #stSettingBrowseDefinitionTest) settings detect: [ :each | each name = aSettingName ].
	^ setting asSettingPresenterWithOwner: (StSettingDetailPresenter newApplication: application)
]

{ #category : 'helpers' }
StSettingBrowseDefinitionTest >> rowForSystemSetting: aSymbol [
	"Answer the row presenter of a real system setting. The browser cannot highlight class side methods of test classes, so browsing tests use system settings."

	^ (self systemSettingNamed: aSymbol) asSettingPresenterWithOwner: (StSettingDetailPresenter newApplication: application)
]

{ #category : 'helpers' }
StSettingBrowseDefinitionTest >> selectedTextIn: aBrowser [

	aBrowser withTool: ClyMethodCodeEditorToolMorph do: [ :editor |
			| interval |
			interval := editor selectedTextInterval.
			^ editor pendingText asString copyFrom: interval first to: interval last ].
	^ nil
]

{ #category : 'running' }
StSettingBrowseDefinitionTest >> setUp [

	super setUp.
	application := StPharoApplication new.
	browsers := OrderedCollection new
]

{ #category : 'helpers' }
StSettingBrowseDefinitionTest >> systemSettingNamed: aSymbol [

	^ (SettingsManager forPragmaNamed: #systemsettings) settings detect: [ :each | each name = aSymbol ]
]

{ #category : 'running' }
StSettingBrowseDefinitionTest >> tearDown [

	browsers do: [ :each | each window ifNotNil: [ :window | window delete ] ].
	super tearDown
]

{ #category : 'tests' }
StSettingBrowseDefinitionTest >> testBooleanRowHasBrowseDefinitionAction [

	self assert: (self browseDefinitionActionOf: (self rowFor: #browsedBoolean)) isNotNil
]

{ #category : 'tests' }
StSettingBrowseDefinitionTest >> testBrowseDefinitionActionBrowsesTheDefinition [

	| opened |
	opened := self browsedWindowsDuring: [ (self browseDefinitionActionOf: (self rowForSystemSetting: #defaultDirectory)) execute ].

	self assert: opened size equals: 1.
	self assert: (self selectedTextIn: opened first) equals: '#defaultDirectory'
]

{ #category : 'tests' }
StSettingBrowseDefinitionTest >> testBrowseDefinitionActionIsBoundToCmdB [

	| action |
	action := self browseDefinitionActionOf: (self rowFor: #browsedBoolean).

	self assert: action shortcutKey equals: $b meta
]

{ #category : 'tests' }
StSettingBrowseDefinitionTest >> testBrowseDefinitionActionIsVisibleInMenus [

	| action |
	action := self browseDefinitionActionOf: (self rowFor: #browsedBoolean).

	self assert: action isVisible
]

{ #category : 'tests' }
StSettingBrowseDefinitionTest >> testBrowseDefinitionHighlightsTheSettingName [
	"The symbol is highlighted, not the bare name, which here starts the selector of the declaring method"

	| browser |
	browser := self browseDefinitionOf: (self rowForSystemSetting: #defaultDirectory).

	self assert: (self selectedTextIn: browser) equals: '#defaultDirectory'
]

{ #category : 'tests' }
StSettingBrowseDefinitionTest >> testBrowseDefinitionOfHelperSettingOpensThePragmaMethod [
	"preferRoundCorner is declared in a helper method called by its pragma method"

	| browser |
	browser := self browseDefinitionOf: (self rowForSystemSetting: #preferRoundCorner).

	self assert: (self editedMethodIn: browser) equals: (self systemSettingNamed: #preferRoundCorner) declaration method
]

{ #category : 'tests' }
StSettingBrowseDefinitionTest >> testBrowseDefinitionOfHelperSettingSelectsNothing [
	"preferRoundCorner is declared in a helper method: its name is not in the pragma method"

	| browser |
	browser := self browseDefinitionOf: (self rowForSystemSetting: #preferRoundCorner).

	self assert: (self selectedTextIn: browser) isEmpty
]

{ #category : 'tests' }
StSettingBrowseDefinitionTest >> testBrowseDefinitionOpensThePragmaMethod [

	| browser |
	browser := self browseDefinitionOf: (self rowForSystemSetting: #defaultDirectory).

	self assert: (self editedMethodIn: browser) equals: StFileBrowserSettings class >> #defaultDirectoryOn:
]

{ #category : 'tests' }
StSettingBrowseDefinitionTest >> testDirectoryRowHasBrowseDefinitionAction [

	| row |
	row := self rowFor: #browsedDirectory.

	self assert: row class equals: StSettingDirectoryPresenterItem.
	self assert: (self browseDefinitionActionOf: row) isNotNil
]

{ #category : 'tests' }
StSettingBrowseDefinitionTest >> testTextRowHasBrowseDefinitionAction [

	self assert: (self browseDefinitionActionOf: (self rowFor: #browsedText)) isNotNil
]

{ #category : 'tests' }
StSettingBrowseDefinitionTest >> testTextRowSharesTheApplicationOfItsPage [
	"The row needs the application of its page to reach the system browser"

	self assert: (self rowFor: #browsedText) application identicalTo: application
]
