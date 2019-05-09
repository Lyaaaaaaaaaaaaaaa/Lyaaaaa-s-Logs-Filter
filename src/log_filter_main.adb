with Log_Filter; use Log_Filter;
with Text_IO; use Text_IO;
procedure Log_Filter_Main is



begin


   select_file("./18th L.txt"); --shall later make it dynamic (with the interface)
   set_filters;



   null;
end Log_Filter_Main;
