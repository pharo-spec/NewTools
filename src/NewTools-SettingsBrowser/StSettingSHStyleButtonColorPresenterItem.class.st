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

	self haltOnce.
]

{ #category : 'enumerating' }
StSettingSHStyleButtonColorPresenterItem >> whenColorChangedDo: aBlock [
	"Inform when presenter has been displayed.
	 `aBlock` receives one argument 
	 - an announcement (instance of `SpWidgetDisplayed`)"

	self announcer
		when: StSettingsChanged
		do: aBlock
		for: aBlock receiver
]
