Class {
	#name : 'HCPharoWebSite',
	#superclass : 'ComposablePresenter',
	#instVars : [
		'link'
	],
	#category : 'HelpCenter',
	#package : 'HelpCenter'
}

{ #category : 'specs' }
HCPharoWebSite class >> defaultSpec [
	^SpecRowLayout composed
		newRow: [ :row | row add: #link ]; 
		yourself
]

{ #category : 'initialization' }
HCPharoWebSite >> initializePresenter [

	"link action: [ WebBrowser openOn: 'https://pharo.org/documentation' ]."

]

{ #category : 'initialization' }
HCPharoWebSite >> initializeWidgets [
	link := self newLabel.
	
	self flag: #todo. "Currently there is no url text color in the theme. I opened a Pharo issue to add that and when it will be integrated to Pharo we should use it here. And later we should directly have a URLPresenter."
	link 
		label: 'Pharo.org Documentation Page';
		color: self theme selectionTextColor
]

{ #category : 'accessing' }
HCPharoWebSite >> link [
	^ link
]

{ #category : 'accessing' }
HCPharoWebSite >> link: anObject [
	link := anObject
]
