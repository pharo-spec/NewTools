"
It represents a setting category page with setting sections and settings. The page was selected from `StSettingsCategoriesPresenter` and it matches a `StSettingsCategoryItemPresenter`.

"
Class {
	#name : 'StSettingsPagePresenter',
	#superclass : 'StSettingsAbstractPresenter',
	#instVars : [
		'pageTitle',
		'settingsBox',
		'settingDocPresenter',
		'settingDocLabel'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'initialization' }
StSettingsPagePresenter >> defaultInputPort [ 

	^ SpModelPort newPresenter: self

]

{ #category : 'layout' }
StSettingsPagePresenter >> defaultLayout [ 

	^ SpBoxLayout newTopToBottom 
		add: pageTitle expand: false;
		add: (SpPanedLayout newVertical 
			positionOfSlider: 0.85;
			add: (SpScrollableLayout with: settingsBox);
			add: (SpBoxLayout newTopToBottom
				spacing: 5;
				add: settingDocLabel expand: false;
				add: settingDocPresenter;
				yourself);
			yourself);
		yourself
]

{ #category : 'initialization' }
StSettingsPagePresenter >> initializePresenters [ 

	pageTitle := self newLabel.
	settingDocLabel := self newLabel
		addStyle: 'settingDocTitle';
		yourself.
	settingDocPresenter := self newText.
	settingsBox := SpBoxLayout newTopToBottom spacing: 10
]

{ #category : 'accessing - model' }
StSettingsPagePresenter >> setModel: aNode [ 
	"Private - Set the receiver's content iterating recursively starting from aNode"

	pageTitle 
		label: aNode label;
		addStyle: 'pageTitle'.
	
	settingsBox removeAll.
	self updatePresenterTree: aNode level: 1.
]

{ #category : 'accessing' }
StSettingsPagePresenter >> updatePresenterTree: aStSettingNode level: anInteger [ 
	"Private - Recursively iterate aStSettingNode children using anInteger as 'level' indicator for title styling purposes"

	aStSettingNode allChildren do: [ : aSettingNode | 
		| nodePresenter |

		nodePresenter := self instantiate: aSettingNode presenterClass on: aSettingNode.
		nodePresenter sectionTitleStyle: 'sectionTitleL' , anInteger asString.	
		settingsBox 
			add: nodePresenter
			expand: false.
		self updatePresenterTree: aSettingNode level: anInteger + 1 ]
]

{ #category : 'accessing' }
StSettingsPagePresenter >> updateSetting: labelString helpText: settingHelpString [

	settingDocLabel label: labelString.
	settingDocPresenter text: settingHelpString.
]
