"
I am an inspector that will be embedded into a debugger. 
The difference is minor, but important: An embedded debugger does not triggers updates to the window (notably its title, but propable others).
  
"
Class {
	#name : #StDebuggerEmbeddedInspector,
	#superclass : #StObjectInspector,
	#category : #'NewTools-Debugger-View'
}

{ #category : #private }
StDebuggerEmbeddedInspector >> updateTitle [
	"just don't"
]
