Class {
	#name : 'StSettingSHStyleButtonColorPresenterItem',
	#superclass : 'StSettingSHStyleButtonPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingSHStyleButtonColorPresenterItem >> buttonColor: aColor [

	self setterPresenter color: aColor.
]

{ #category : 'initialization' }
StSettingSHStyleButtonColorPresenterItem >> updateColor: aColor [

	self buttonColor: aColor.
]
