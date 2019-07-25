--Custom include

with Log_Filter_Handlers;


procedure Log_Filter_Main is

begin

   Log_Filter_Handlers.Init; -- Start Gtkada and create objects.
   Log_Filter_Handlers.Connect_Interface; -- Load interface and links objects.
   Log_Filter_Handlers.Register_Handlers; -- Links signals and handlers.
   Log_Filter_Handlers.Start_Interface; -- Display the main window.

   null;
end Log_Filter_Main;
