"
I am an inspector that will be embedded into a debugger. 
The difference is minor, but important: An embedded debugger does not triggers updates to the window (notably its title, but propable others).
  
"
Class {
	#name : #StDebuggerEmbeddedInspector,
	#superclass : #StInspector,
	#category : #'NewTools-Debugger-View'
}

{ #category : #initialization }
StDebuggerEmbeddedInspector >> initializeViews [

	views := self newNotebook.
	views pages: self allPages
]

{ #category : #private }
StDebuggerEmbeddedInspector >> updateTitle [
	"just don't"
]
