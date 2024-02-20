# Debug Points Browser

The debug points browser is a new tool to visualize and configure existing debug points.
Full details on the new debug points model are [described here](https://github.com/pharo-project/pharo/blob/Pharo12/doc/DebugPoints/debug-points.md)

The tool can be opened via the `Debug > Debug Point Browser` world menu and looks like that: 

![Opening Debug Point Browser via the World menu](https://github.com/pharo-spec/NewTools/assets/97704417/1cacd05d-f459-4a5c-bd9e-6587a89d6a95)

On the top-left, a table allows to visualize all debug points (breakpoints/watchpoints/basic debug points/etc.)
Each debug point has a name, which we could assimilate to a tag, that can be edited directly in this table.
The "enabled" state of the debug point is also displayed via a checkbox, as well as the scope of the debug point (class or object).

All behaviors of the selected can be configured via the right pane of debug point browser

When a debug point is selected, according to the target of the debug point, different information are displayed.
If the target is an AST node, the code of the concerned method is displayed (as in the screenshot above), while highlighting the corresponding code
If the target is an instance variable, all concerned methods are listed and selecting a method displays the corresponding code and highlights the correct variable accesses:

![image](https://github.com/pharo-spec/NewTools/assets/97704417/4c746e55-c50b-4a0f-97a6-9812acb5ca57)

Also, if the target is an instance variable, it is possible to configure the accesss strategy on which the debug point should be hit.

It is possible to filter the displayed debug points by name, thanks to an input field at the top. Validating the input field will filter so that all the remaining debug points contain the entered sequence of characters in their name:

![image](https://github.com/pharo-spec/NewTools/assets/97704417/c42d125e-bb45-4836-a524-b00f3364c6e5)

## Object-centric debug points

To set object-centric debug points, the second button in the inspector toolbar, with the `objects` icon, allows to do the same thing in the same way as former object-centric breakpoints So, this is possible to set object-centric breakpoints and watchpoints on all variables of a target for this object:

![image](https://github.com/adri09070/NewTools/assets/97704417/295fd03f-3591-47b1-b808-67d21d45a678)

Just as it was possible before debug points existed, it is still possible to set debug points on only some instance variables of the objects.
To do that, from the raw view in the inspector, select the variables you want to watch/break on and right-click to open a context menu to install breakpoints/watchpoints on them:

![image](https://github.com/adri09070/NewTools/assets/97704417/41f65031-36be-4659-9d71-87c43ab6284a)

Moreover, you can set object-centric breakpoints from the meta view in the inspector. Right-click on the method on which you want to break and select **Break on call** or **Break once on call**:

![image](https://github.com/adri09070/NewTools/assets/97704417/32dbf212-5eef-410e-b60d-331c0e2de31e)

Last but not least, it is also possible to change the scope of an existing debug point to an object, which was not possible before.
The third button in the inspector toolbar, with the `debug` icon, allows to do that and opens a modal to choose a debug point whose scope should be changed to the inspected object:

![image](https://github.com/pharo-spec/NewTools/assets/97704417/1d254ee1-704d-4501-878d-176a2b2e71af)


