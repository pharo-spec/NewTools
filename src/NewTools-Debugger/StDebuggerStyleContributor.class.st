"
A contributor to add styles referred to the debugger.
"
Class {
	#name : 'StDebuggerStyleContributor',
	#superclass : 'StPharoStyleContributor',
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'styles' }
StDebuggerStyleContributor >> styleSheetContribution [

	^ SpStyle newApplication
		addClass: 'stDebuggerStackContextInSelectedClass' with: [ :class |
			class addPropertyDrawWith: [ :draw |
				draw color: Smalltalk ui theme highlightTextColor ] ];
		addClass: 'stDebuggerStackContextInSelectedPackage' with: [ :class |
			class addPropertyDrawWith: [ :draw |
				draw color: (Smalltalk ui theme highlightTextColor 
					mixed: 0.5 
					with: Smalltalk ui theme textColor) ] ]
]
