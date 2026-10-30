"
I test StSettingButtonPresenterItem, the presenter of action settings.
"
Class {
	#name : 'StSettingButtonPresenterItemTest',
	#superclass : 'TestCase',
	#instVars : [
		'actionCount',
		'page',
		'item'
	],
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'helpers' }
StSettingButtonPresenterItemTest >> clickButton [

	item setterPresenter click
]

{ #category : 'helpers' }
StSettingButtonPresenterItemTest >> recordAction [
	"Action of the tested button"

	actionCount := actionCount + 1
]

{ #category : 'running' }
StSettingButtonPresenterItemTest >> setUp [

	super setUp.
	actionCount := 0.
	page := StSettingDetailPresenter new.
	item := (ActionSetting new
		         name: #recordAction;
		         target: self;
		         buttonLabel: 'Do';
		         yourself) asSettingPresenterWithOwner: page
]

{ #category : 'tests' }
StSettingButtonPresenterItemTest >> testClickPerformsTheAction [

	self clickButton.

	self assert: actionCount equals: 1
]

{ #category : 'tests' }
StSettingButtonPresenterItemTest >> testClickRefreshesTheSettingsPage [

	| refreshCount |
	refreshCount := 0.
	page announcer
		when: StSettingModelChanged
		do: [ refreshCount := refreshCount + 1 ]
		for: self.

	self clickButton.

	self assert: refreshCount equals: 1
]

{ #category : 'tests' }
StSettingButtonPresenterItemTest >> testItemKnowsItsSettingsPage [

	self assert: item pagePresenter identicalTo: page
]
