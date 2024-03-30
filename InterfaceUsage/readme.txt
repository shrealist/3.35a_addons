Description
-----------
Using this tool, you can find culprits in your World of Warcraft interface, that are slowing down the overall performance.

Each polling type is not initialised, and will thus not take up resources, until you select it in the drop down menu.
And nothing is initialised at all until you open the addon using the slash command.

Some of the polling methods will have an overhead once initialised, an example are the Frame OnEvent/OnUpdate modules.
They will hook many frames in your interface, and may slow things down a little. So it's best to reload the UI when done testing.

Once a polling method has been initialised, you can close the window, and it will still gather data in the background.

Slash command for this tool is "/iu".

Polling Modules (8)
-------------------
Currently, eight polling moduels exists for this addon.

<Addon Memory Usage>
Shows the memory usage of all addons.

<Addon CPU Usage>
Measures how much CPU time each addon uses. The option "Script Profiling" must be enabled for this polling to work.

<Addon Spam by Prefix>
Shows how many addon messages each addon does.

<Addon Spam by Player>
Shows how many addon messages you get from who.

<Addon Spam by Channel>
Shows how many addon messages you get per channel.

<Event Calls>
Shows how many times each event is dispatched to a frame.

<Frame OnEvent Usage>
Hooks all frames in the user interface that has an "OnEvent" script, and measures how much time they spend running this function.

<Frame OnUpdate Usage>
Hooks all frames in the user interface that has an "OnUpdate" script, and measures how much time they spend running this function.

Lacking Features, Ideas & Problems
----------------------------------
- Customisable polling interval.
- Column header text.