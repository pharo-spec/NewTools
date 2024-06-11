"
It represents a setting node (presenter) without children. This is used to represent final nodes, i.e. actual setters for a particular setting.

## Instance Variables

- settingPresenter : `SpPresenter`

"
Class {
	#name : 'StSettingNodePresenter',
	#superclass : 'StSettingPresenter',
	#instVars : [
		'settingPresenter'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'instance creation' }
StSettingNodePresenter class >> with: aPragmaSetting [ 

	^ self new setItem: aPragmaSetting
]

{ #category : 'layout' }
StSettingNodePresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		vAlignCenter;
		add: settingPresenter;
		yourself
]

{ #category : 'initialization' }
StSettingNodePresenter >> initializePresenters [

	self addStyle: 'settingItemStyle'.
	settingPresenter := settingNode asPresenter.
	super initializePresenters.

]
