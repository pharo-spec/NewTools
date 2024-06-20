"
It represents a setting node Spec presenter with children (a section).
"
Class {
	#name : 'StSettingSectionPresenter',
	#superclass : 'StSettingPresenter',
	#instVars : [
		'detailBox'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'instance creation' }
StSettingSectionPresenter class >> with: aPragmaSetting [ 

	^ self new setItem: aPragmaSetting
]

{ #category : 'layout' }
StSettingSectionPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: title height: 30;
		add: (detailBox := SpBoxLayout newTopToBottom
			spacing: 20;
			yourself);
		yourself
]
