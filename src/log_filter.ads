with Text_IO; use Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Text_IO.Unbounded_IO;

package Log_Filter is

   -- ===== Variables declaration =====
   
   file : File_Type;
   line : Unbounded_String;
   
   type store_Filter is
     array (Positive range <>, Positive range <>) of Character;
   --Shall later edit the range to dynamically create store_filters
   --with as many filters we want 
   filters : store_Filter(1 .. 40, 1..10); 
   
   
   -- ===== functions declaration =====
 
   procedure select_file(p_file : String);
   procedure display_line;
   procedure read_line;
   function filter_check return Boolean;
end Log_Filter;
