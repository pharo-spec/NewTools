"
It represents a setting category page with setting sections and settings. The page was selected from `StSettingsCategoriesPresenter` and it matches a `StSettingsCategoryItemPresenter`.

"
Class {
	#name : 'StSettingsPagePresenter',
	#superclass : 'StSettingsAbstracPresenter',
	#instVars : [
		'pageTitle',
		'settingsBox'
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
		add: (SpScrollableLayout with: (settingsBox := SpBoxLayout newTopToBottom spacing: 10));
		yourself
]

{ #category : 'initialization' }
StSettingsPagePresenter >> initializePresenters [ 

	pageTitle := self newLabel.
	self layout: self defaultLayout.

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
