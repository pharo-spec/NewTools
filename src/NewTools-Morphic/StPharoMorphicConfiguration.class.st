Class {
	#name : #StPharoMorphicConfiguration,
	#superclass : #SpApplicationConfiguration,
	#category : #'NewTools-Morphic'
}

{ #category : #'as yet unclassified' }
StPharoMorphicConfiguration class >> defaultStyleSheet [

	^ SpStyleSTONReader fromString: '
.application [
	Font { #name : "Source Sans Pro", #size : 10 },
	Geometry { #height: 25 },
	.label [
		Geometry { #hResizing: true }		
	],
	.link [  
		Geometry { #hResizing: true }		
	],
	.button [  
		Geometry { #width: 25 }
	],
	.checkBox [  
		Geometry { #hResizing: true }
	],
	.radioButton [ 
		Geometry { #hResizing: true }
	],
	.dropList [ 
		Geometry { #width: 150, #hResizing: true }
	],
	.list [ 
		Geometry { #width: 150, #hResizing: true, #vResizing: true }
	],
	.slider [
		Geometry { #width: 150, #hResizing: true }
	],
	.actionBar [  
		Container { #borderWidth: 5, #padding: 5 },
		Geometry { #width: 150, #hResizing: true }
	],
	.menuBar [
		Geometry { #width: 150, #hResizing: true }
	],
	.actionButton [  
		Geometry { #width: 80, #hResizing: true }
	]
]
'.

]

{ #category : #accessing }
StPharoMorphicConfiguration class >> styleSheetPropertyName [

	^ #styleSheet
]

{ #category : #configuring }
StPharoMorphicConfiguration >> configure: anApplication [

	super configure: anApplication.
	anApplication 
		propertyAt: self class styleSheetPropertyName
		put: self class defaultStyleSheet
]
