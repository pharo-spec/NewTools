"
I test StSettingTextPresenterItem, the presenter of settings holding a string.
The tested setting has no target: it inherits the target of its group, which is me.
"
Class {
	#name : 'StSettingTextPresenterItemTest',
	#superclass : 'TestCase',
	#instVars : [
		'text',
		'item'
	],
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'running' }
StSettingTextPresenterItemTest >> setUp [

	super setUp.
	text := 'initial'.
	item := (Setting new
		         name: #text;
		         parentGroup: (SettingsGroup new
				          name: #group;
				          target: self;
				          yourself);
		         yourself) asSettingPresenterWithOwner: StSettingDetailPresenter new
]

{ #category : 'tests' }
StSettingTextPresenterItemTest >> testEditingWritesToTheTargetOfTheGroup [

	item setterPresenter text: 'edited'.

	self assert: text equals: 'edited'
]

{ #category : 'tests' }
StSettingTextPresenterItemTest >> testItemShowsTheValueOfTheTargetOfTheGroup [

	self assert: item setterPresenter text equals: 'initial'
]

{ #category : 'accessing' }
StSettingTextPresenterItemTest >> text [
	"Value of the tested setting"

	^ text
]

{ #category : 'accessing' }
StSettingTextPresenterItemTest >> text: aString [

	text := aString
]
