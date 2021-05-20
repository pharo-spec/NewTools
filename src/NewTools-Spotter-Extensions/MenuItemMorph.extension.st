Extension { #name : #MenuItemMorph }

{ #category : #'*NewTools-Spotter-Extensions' }
MenuItemMorph >> spotterPreview: aBuilder [

	^ self balloonText spotterPreview: aBuilder
]

{ #category : #'*NewTools-Spotter-Extensions' }
MenuItemMorph >> stActDefault [
	self doButtonAction
]
