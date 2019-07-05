--Custom include

with Log_Filter_Handlers;


procedure Log_Filter_Main is

begin

   Log_Filter_Handlers.Init;
   Log_Filter_Handlers.Connect_Interface;
   Log_Filter_Handlers.Register_Handlers;
   Log_Filter_Handlers.Start_Interface;

   null;
end Log_Filter_Main;
