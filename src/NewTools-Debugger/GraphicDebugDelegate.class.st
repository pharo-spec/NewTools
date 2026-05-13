Class {
	#name : 'GraphicDebugDelegate',
	#superclass : 'Object',
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'ui requests' }
GraphicDebugDelegate >> chooseTraitOverwriteFor: aClass trait: aTrait [

	^ UIManager default
		  chooseFrom: {
				  ('Create copy in ' , aClass name).
				  ('Compile Trait method in ' , aTrait name) }
		  values: {
				  aClass.
				  aTrait }
		  title: 'Where do you want to compile this trait method?'
]

{ #category : 'ui requests' }
GraphicDebugDelegate >> confirm: message [

	^ UIManager default confirm: message trueChoice: 'Compile and Browse' falseChoice: 'Cancel'
]
